{ModuleProtocol, ModuleAdapterProtocol} = require './../module_protocol'
MODULE_TYPE = "cj_file"


class SinglCjsFileModule extends ModuleProtocol
    getType: -> MODULE_TYPE
    getFiles: -> @getPath()


class SingleCjsFileAdapter extends ModuleAdapterProtocol
    getModuleType: -> MODULE_TYPE
    getModuleClass: -> SinglCjsFileModule


module.exports = {
    adapter: new SingleCjsFileAdapter()
    MODULE_TYPE
    SinglCjsFileModule
}
