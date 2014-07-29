async = require 'async'
_ = require 'lodash'


parse_bundle = (recipe, modules, bundle, cb) ->
    validate_bundle = ({name, bundle}, cb) ->
        if bundle.hasOwnProperty "modules"
            cb null, {name, bundle}
        else
            cb "Bundle #{name} has no modules section"

    validate_bundle_modules = (modules, {name, bundle}, cb) ->
        modulesMap = {}
        for m in modules
            modulesMap[m.getName()] = null

        module_exists = (m, cb) ->
            if m of modulesMap
                cb null
            else
                cb """Unknown module #{m} from bundle #{name}"""

        async.map bundle.modules, module_exists, cb

    async.waterfall([
        (_.partial validate_bundle, bundle)
        (_.partial validate_bundle_modules, modules)
        ], cb)


parse_bundles = (recipe, mods, cb) ->
    _bundles = ({name:n, bundle} for n, bundle of recipe.bundles)
    _iterate_func = _.partial parse_bundle, recipe, mods
    async.map _bundles, _iterate_func, cb


module.exports = {parse_bundles}
