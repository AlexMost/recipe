async = require 'async'
Q = require 'q'
{parse_bundles} = require '../src/bundles_parser'
{parse_recipe} = require '../src/recipe_parser'
{parse_modules} = require '../src/module_parser'
{dispatch_modules} = require '../src/module_dispatcher'


read_recipe_modules = (filename, cb) ->
    {adapter} = require '../src/module_types/single_cjs_module'

    q_recipe = Q.nfcall parse_recipe, filename

    q_rawModules = q_recipe.then (recipe) ->
        Q.nfcall parse_modules, recipe.modules

    q_modules = q_rawModules.then (modules) ->
        Q.nfcall dispatch_modules, modules, [adapter]

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



