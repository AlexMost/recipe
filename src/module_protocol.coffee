# naive implementation of protocol for modules


class ModuleProtocol
    constructor: ({@name, @path, @deps, @opts}) ->
        (throw Error "module name is missing") unless @name
        (throw Error "module path is missing") unless @path
        @deps or= []

    getName: -> @name
    getPath: -> @path
    getDeps: -> @deps
    getOpts: -> @opts

    getType: -> throw (Error "getType is not implemented")
    getFiles: -> throw (Error "getFiles is not implemented")


class ModuleAdapterProtocol
    getModuleType: -> throw (Error "getModuleType is not implemented")
    getModuleClass: -> throw (Error "getModuleClass is not implemented")


class ModuleTypeError
    constructor: (@message) ->
        @message or= ""
        @name = "ModuleTypeError"


class ModueAdapterTypeError
    constructor: (@message) ->
        @message or= ""
        @name = "ModueAdapterTypeError"


module.exports = {ModuleProtocol, ModuleAdapterProtocol, ModuleTypeError,
ModueAdapterTypeError}
