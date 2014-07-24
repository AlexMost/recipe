# naive implementation of protocol for modules


class ModuleProtocol
    constructor: ({@name, @path, @deps, @opts}) ->
        (throw "module name is missing") unless name
        (throw "module path is missing") unless path
        @deps or= []

    getName: -> @name
    getPath: -> @path
    getDeps: -> @deps
    getOpts: -> @opts

    getType: -> throw "getType is not implemented"
    getFiles: -> throw "getFiles is not implemented"


class ModuleAdapterProtocol
    isValidFormat: -> throw "isValid method is not implemented"
    isMatch: -> throw "isMatch method is not implemented"


module.exports = {ModuleProtocol, ModuleAdapterProtocol}
