{dispatch_modules} = require '../src/module_dispatcher'
{parse_modules} = require '../src/module_parser'
{ModuleProtocol, ModuleAdapterProtocol,
ModuleTypeError, ModueAdapterTypeError} = require '../src/module_protocol'


exports.test_signle_cjs_module_dispatch = (test) ->
    {MODULE_TYPE, adapter: cj_adapter, SinglCjsFileModule
    } = require '../src/module_types/single_cjs_module'

    _modules =
        module1: ["./some/path.coffee", MODULE_TYPE]
        module2: ["./some/path2.coffee", MODULE_TYPE]

    parse_modules _modules, (err, raw_modules) ->
        test.ok !err, err
        dispatch_modules raw_modules, [cj_adapter], (err, modules) ->
            test.ok !err, err
            test.ok modules.length is 2, "must be 2 result modules"
            [module1, module2] = modules
            test.ok(
                module1 instanceof SinglCjsFileModule
                "module must be instance of SinglCjsFileModule")
            test.ok(
                module2 instanceof SinglCjsFileModule
                "module must be instance of SinglCjsFileModule")
            test.done()


exports.throws_exception_if_wrong_adapter_type = (test) ->
    {MODULE_TYPE, adapter: cj_adapter, SinglCjsFileModule
    } = require '../src/module_types/single_cjs_module'

    _modules =
        module1: ["./some/path.coffee", MODULE_TYPE]
        module2: ["./some/path2.coffee", MODULE_TYPE]

    parse_modules _modules, (err, raw_modules) ->
        test.ok !err, err
        test.throws(
            (->
                dispatch_modules raw_modules, [cj_adapter, "fake"], ->)
            ModueAdapterTypeError
            "must throw type Error")
        test.done()


exports.throws_exception_if_wrong_module_type = (test) ->
    MODULE_TYPE = "cj_file"
    class Fake
    class MockAdapter extends ModuleAdapterProtocol
        getModuleType: -> ""
        getModuleClass: -> Fake

    _modules =
        module1: ["./some/path.coffee", MODULE_TYPE]
        module2: ["./some/path2.coffee", MODULE_TYPE]

    parse_modules _modules, (err, raw_modules) ->
        test.ok !err, err
        test.throws(
            ->
                (dispatch_modules raw_modules, [new MockAdapter()], ->)
                ModuleTypeError
                "must throw module type Error")
        test.done()
        

