# naive implementation of protocol for modules


class ModuleProtocol
    constructor: ({@name, @path, @deps, @opts}) ->
        (throw Error "module name is missing") unless name
        (throw Error "module path is missing") unless path
        @deps or= []

    getName: -> @name
    getPath: -> @path
    getDeps: -> @deps
    getOpts: -> @opts

    getType: -> throw (Error "getType is not implemented")
    getFiles: -> throw (Error "getFiles is not implemented")


class ModuleAdapterProtocol
    isValidFormat: -> throw (Error "isValid method is not implemented")
    isMatch: -> throw (Error "isMatch method is not implemented")


module.exports = {ModuleProtocol, ModuleAdapterProtocol}
