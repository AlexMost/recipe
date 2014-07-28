async = require 'async'
{ModuleProtocol, ModuleAdapterProtocol,
ModuleTypeError, ModueAdapterTypeError} = require './module_protocol'


getModuleTypesDispatcher = (moduleAdapters, cb) ->
    typeMap = {}

    for m in moduleAdapters
        typeMap[m.getModuleType()] = m.getModuleClass()

    dispatcher = {
        dispatchRawModule: (module, cb) ->

            if module.type of typeMap
                cb null, new typeMap[module.type](module)
            else
                cb """
                    module #{module.name} has unknown module
                    type #{module.type}
                    """
    }

    cb null, dispatcher


check_adapters_types = (adapters) ->
    for adapter in adapters
        unless adapter instanceof ModuleAdapterProtocol
            (throw new ModueAdapterTypeError("""
                module adapters must be instance of
                ModuleAdapterProtocol"""))


check_modules_types = (modules) ->
    for module in modules
        unless module instanceof ModuleProtocol
            (throw new ModuleTypeError("""
                modules must be instance of
                ModuleProtocol
                """))


dispatch_modules = (modules, adapters, cb) ->
    check_adapters_types adapters

    getModuleTypesDispatcher adapters, (err, dispatcher) ->
        cb err if err
        async.map(
            modules
            dispatcher.dispatchRawModule
            (err, dispatchedModules) ->
                if err
                    cb err 
                else
                    check_modules_types dispatchedModules
                    cb null, dispatchedModules
        )


module.exports = {dispatch_modules}

