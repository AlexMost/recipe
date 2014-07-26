async = require 'async'
{ModuleProtocol} = require './module_protocol'

# TODO: tests for type match for modules
getModuleTypesDispatcher = (moduleAdapters, cb) ->
    typeMap = {}
    for m in moduleAdapters
        typeMap[m.getModuleType()] = m.getModuleClass()

    dispatcher = {
        dispatchRawModule: (module, cb) ->
            cb null, new typeMap[module.type](module)
    }

    cb null, dispatcher


dispatch_modules = (modules, adapters, cb) ->
    getModuleTypesDispatcher adapters, (err, dispatcher) ->
        (cb err) if err
        async.map modules, dispatcher.dispatchRawModule, cb


module.exports = {dispatch_modules}

