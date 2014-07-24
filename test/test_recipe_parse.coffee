{parse_recipe, validate_recipe_structure} = require '../src/recipe_parser'

exports.can_read_recipe = (test) ->
    test.expect()
    filepath = './test/fixtures/correct_recipe.yaml'
    parse_recipe filepath, (err, cb) ->
        test.ok !err, err
        test.done()

exports.fail_if_abstract_is_not_present = (test) ->
    recipe = bundles: bundle1: modules: []
    validate_recipe_structure recipe, (err, recipe) ->
        test.ok err, "must fail without abstract section"
        test.done()

exports.fail_if_version_is_not_present = (test) ->
    recipe =
        abstract: []
        bundles:
            bundle1: modules: []

    validate_recipe_structure recipe, (err, recipe) ->
        test.ok err, "must fail without version"
        test.done()

exports.fail_if_version_number_is_invalid = (test) ->
    recipe =
        abstract: version: "fjdk"
        bundles:
            bundle1: modules: []

    validate_recipe_structure recipe, (err, recipe) ->
        test.ok err, "version must have correct format"
        test.done()

exports.fail_if_has_no_bundles_or_realms = (test) ->
    recipe = abstract: version: "fjdk"
    validate_recipe_structure recipe, (err, recipe) ->
        test.ok err, "must fail if has not bundles or realm section"
        test.done()

exports.recipe_object_must_be_frozen = (test) ->
    filepath = './test/fixtures/correct_recipe.yaml'
    parse_recipe filepath, (err, recipe) ->
        test.ok Object.isFrozen recipe
        test.done()
