{read_yaml_file} = require '../src/utils'


exports.test_read_yaml = (test) ->
    filepath = './test/fixtures/test_recipe_read.yaml'

    test_data =
        modules: ["module1", "module2"]
        bundles:
            bundle1: [1, 2, 3]

    read_yaml_file filepath, (err, data) ->
        test.ok !err
        test.deepEqual data, test_data
        test.done()
