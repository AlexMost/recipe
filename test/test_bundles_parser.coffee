async = require 'async'
Q = require 'q'
{parse_bundles} = require '../src/bundles_parser'
{parse_recipe} = require '../src/recipe_parser'
{parse_modules} = require '../src/module_parser'


read_recipe_modules = (filename, cb) ->
    q_recipe = Q.nfcall parse_recipe, filename

    q_modules = q_recipe.then (recipe) ->
        Q.nfcall parse_modules, recipe.modules

    Q.all([q_recipe, q_modules]).spread cb


exports.must_fail_if_bundle_has_no_modules_section = (test) ->
    filename = './test/fixtures/bundles_parser_recipe.yaml'
    read_recipe_modules filename, (recipe, modules) ->
        parse_bundles recipe, modules, (err, bundles) ->
            test.ok err, "must fail if has no modules section"
            test.done()


exports.must_fail_if_some_module_does_not_exist = (test) ->
    filename = './test/fixtures/bundle_parser_missing_module.yaml'
    read_recipe_modules filename, (recipe, modules) ->
        parse_bundles recipe, modules, (err, bundles) ->
            test.ok err, "must fail if has not existent module"
            test.done()


exports.must_resolve_modules_dependencies = (test) ->
    filename = './test/fixtures/bundle_parser_with_deps.yaml'
    read_recipe_modules filename, (recipe, modules) ->
        parse_bundles recipe, modules, (err, bundles) ->
            test.ok !err, "must parse recipe with modules deps"
            test.ok bundles.length is 1, "must be 1 bundle"
            [bundle] = bundles
            test.deepEqual(
                bundle.getModules()
                ["module3", "module2", "module1"]
                "must resolve bundles dependencies")
            test.done()


exports.must_fail_on_circular_dependencies = (test) ->
    filename = './test/fixtures/bundle_parser_with_circular_deps.yaml'
    read_recipe_modules filename, (recipe, modules) ->
        parse_bundles recipe, modules, (err, bundles) ->
            test.ok err, "must fail if circular deps"
            test.done()



