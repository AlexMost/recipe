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


parse_module = ([name, module], cb) ->
    switch
        when _.isObject module then parse_if_object name, module, cb
        else cb "unknown module format for module #{name}"


parse_modules = (modules, cb) ->
    _modules = ([name, module] for name, module of modules)
    async.map _modules, parse_module, cb


module.exports = {parse_modules, RawModule}