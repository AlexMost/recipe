{parse_recipe} = require '../src/recipe_parser'

exports.can_read_recipe = (test) ->
    test.expect()
    filepath = './test/fixtures/correct_recipe.yaml'
    parse_recipe filepath, (err, cb) ->
        test.ok !err, err
        test.done()