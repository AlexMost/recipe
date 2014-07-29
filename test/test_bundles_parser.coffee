async = require 'async'
Q = require 'q'

{parse_bundles} = require '../src/bundles_parser'
{parse_recipe} = require '../src/recipe_parser'
{parse_modules} = require '../src/module_parser'
{dispatch_modules} = require '../src/module_dispatcher'


exports.must_fail_if_bundle_has_no_modules_section = (test) ->
    filename = './test/fixtures/bundles_parser_recipe.yaml'
    {adapter} = require '../src/module_types/single_cjs_module'

    q_recipe = Q.nfcall parse_recipe, filename

    q_rawModules = q_recipe.then (recipe) ->
        Q.nfcall parse_modules, recipe.modules

    q_modules = q_rawModules.then (modules) ->
        Q.nfcall dispatch_modules, modules, [adapter]

    Q.all([q_recipe, q_modules]).spread (recipe, modules) ->
        parse_bundles recipe, modules, (err, bundles) ->
            test.ok err, "must fail if has no modules section"
            test.done()


exports.must_fail_if_some_module_does_not_exist = (test) ->
    filename = './test/fixtures/bundle_parser_missing_module.yaml'
    {adapter} = require '../src/module_types/single_cjs_module'

    q_recipe = Q.nfcall parse_recipe, filename

    q_rawModules = q_recipe.then (recipe) ->
        Q.nfcall parse_modules, recipe.modules

    q_modules = q_rawModules.then (modules) ->
        Q.nfcall dispatch_modules, modules, [adapter]

    Q.all([q_recipe, q_modules]).spread (recipe, modules) ->
        parse_bundles recipe, modules, (err, bundles) ->
            test.ok err, "must fail if has not existent module"
            test.done()



