async = require 'async'
{ModuleProtocol, ModuleAdapterProtocol} = require './module_protocol'


getModuleTypesDispatcher = (moduleAdapters, cb) ->
    typeMap = {}

    for m in moduleAdapters
        typeMap[m.getModuleType()] = m.getModuleClass()

    dispatcher = {
        dispatchRawModule: (module, cb) ->
            cb null, new typeMap[module.type](module)
    }

    cb null, dispatcher


check_adapters_types = (adapters) ->
    for adapter in adapters
        unless adapter instanceof ModuleAdapterProtocol
            (throw new Error("""
                module adapters must be instance of
                ModuleAdapterProtocol"""))


check_modules_types = (modules) ->
    for module in modules
        unless module instanceof ModuleProtocol
            (throw new Error("""
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
                cb err if err
                check_modules_types dispatchedModules
                cb null, dispatchedModules
        )


module.exports = {dispatch_modules}

