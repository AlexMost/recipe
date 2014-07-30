async = require 'async'
_ = require 'lodash'


class RawModule
    constructor: (@name, {@path, @deps, @opts, @type}) ->
        @deps or= []
        @opts or= {}

    getName: -> @name
    getPath: -> @path
    getDeps: -> @deps
    getOpts: -> @opts
    getType: -> @type


parse_module_as_object = (name, module, cb) ->
    switch
        when not module.path then\
            cb "module path #{module.name} is undefined"
        when not module.type then\
            cb "module type #{module.name} is undefined"
        else
            cb null, new RawModule(name, module)


parse_module_as_list = (name, module, cb) ->
    [path, type, deps, opts] = module
    switch
        when not path then\
            cb "module path #{module.name} is undefined"
        when not type then\
            cb "module type #{module.name} is undefined"
        else
            cb null, new RawModule(name, {path, type, deps, opts})


parse_module = ([name, module], cb) ->
    switch
        when _.isPlainObject module then parse_module_as_object name, module, cb
        when _.isArray module then parse_module_as_list name, module, cb
        else cb "unknown module format for module #{name}"


validate_module_deps = (modules, module, cb) ->
    modulesMap = {} # for fast in check O(1)
    (modulesMap[m.getName()] = m) for m in modules

    check_module_dep = (dep, cb) ->
        if dep of modulesMap
            cb null, module
        else
            cb "Unkown dependency #{dep} for module #{module.getName()}"

    async.map module.getDeps(), check_module_dep, (err, mods) ->
        return cb err if err
        cb null, module


parse_modules = (modules, cb) ->
    _modules = ([name, module] for name, module of modules)
    async.map _modules, parse_module, (err, modules) ->
        return cb err if err
        async.map(
            modules
            (_.partial validate_module_deps, modules)
            cb)


module.exports = {parse_modules, RawModule}
