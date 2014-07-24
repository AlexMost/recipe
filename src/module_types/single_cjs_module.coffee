{ModuleProtocol, ModuleAdapterProtocol} = require './../module_protocol'


class SinglCjsFileModule extends ModuleProtocol
    getType: -> "single_cjs_file"
    getFiles: -> @path


class SingleCjsFileAdapter extends ModuleAdapterProtocol
    isValidFormat: (data) -> !! data.path
    isMatch: (data) -> data.type is "single_cjs_file"


single_cjs_file_module_processor =
    name: "single_cjs_file"
    adapter: SingleCjsFileAdapter()
    moduleClass: SinglCjsFileModule