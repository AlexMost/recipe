{parse_modules, RawModule} = require '../src/module_parser'


exports.test_parse_if_object = (test) ->
    modules =
        module1:
            type: "commonjs_file"
            path: "./some/path.coffee"

        module2:
            type: "commonjs_file2"
            path: "./some/path2.coffee"

    parse_modules modules, (err, modules) ->
        test.ok !err, err
        test.ok modules.length is 2, "must be 2 reslt modules"
        modules.map (m) ->
            test.ok(
                m instanceof RawModule
                "modules must be instanceof RawModule")
        test.done()