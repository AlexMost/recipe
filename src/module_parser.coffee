async = require 'async'
_ = require 'lodash'


class RawModule
    constructor: (@name, {@path, @deps, @opts, @type}) ->
        @deps or= []
        @opts or = {}

    getName: -> @name
    getPath: -> @path
    getDeps: -> @deps
    getOpts: -> @opts
    getType: -> @type


parse_if_object = (name, module, cb) ->
    switch
        when not module.path then\
            cb "module path #{module.name} is undefined"
        when not module.type then\
            cb "module type #{module.name} is undefined"
        else
            cb null, new RawModule(name, module)


parse_if_list = (name, module, cb) ->
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
        when _.isPlainObject module then parse_if_object name, module, cb
        when _.isArray module then parse_if_list name, module, cb
        else cb "unknown module format for module #{name}"


parse_modules = (modules, cb) ->
    _modules = ([name, module] for name, module of modules)
    async.map _modules, parse_module, cb


dispatch_modules = (recipe, cb) ->
    async.waterfall([
        _.partial(parse_modules, recipe)
        ]
        cb)

module.exports = {parse_modules, dispatch_modules, RawModule}
