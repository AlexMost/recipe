async = require 'async'
_ = require 'lodash'
toposort = require 'toposort'

class Bundle
    constructor: (@name, @bundle, @modules) ->
    getModules: -> @modules
    getName: -> @name


parse_bundle = (recipe, modules, bundle, cb) ->
    modulesMap = {} # for fast in check O(1)
    (modulesMap[m.getName()] = m) for m in modules

    validate_bundle = ({name, bundle}, cb) ->
        if bundle.hasOwnProperty "modules"
            cb null, {name, bundle}
        else
            cb "Bundle #{name} has no modules section"

    validate_bundle_modules = (modules, {name, bundle}, cb) ->
        module_exists = (m, cb) ->
            if m of modulesMap
                cb null, {name, bundle}
            else
                cb """Unknown module #{m} from bundle #{name}"""
        async.map bundle.modules, module_exists, cb

    create_bundle = (modules, {name, bundle}, cb) ->
        _bundle_modules = {}
        no_deps_modules = []

        for m in bundle.modules
            _bundle_modules[m] = null
            for d in modulesMap[m].getDeps()
                _bundle_modules[d] = null

        toposort_graph = []
        for module of _bundle_modules
            toposort_graph
            deps = modulesMap[module].getDeps()

            if deps.length
                (toposort_graph.push [module, d]) for d in deps
            else
                no_deps_modules.push(module)

        sorted_modules = toposort(toposort_graph).reverse()
        for m in no_deps_modules
            (sorted_modules.unshift m) unless m in sorted_modules

        cb null, (new Bundle name, bundle, sorted_modules)

    create_bundles = (modules, bundles, cb) ->
        iterate_bundle = (b, cb) -> create_bundle(modules, b, cb)
        async.map bundles, iterate_bundle, cb

    async.waterfall([
        (_.partial validate_bundle, bundle)
        (_.partial validate_bundle_modules, modules)
        (_.partial create_bundles, modules)]
        cb)


parse_bundles = (recipe, mods, cb) ->
    _bundles = ({name:n, bundle} for n, bundle of recipe.bundles)
    _iterate_func = _.partial parse_bundle, recipe, mods
    async.map _bundles, _iterate_func, (err, bundles) ->
        return cb err if err
        cb null, _.flatten bundles


module.exports = {parse_bundles}
