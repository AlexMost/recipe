{get_recipe_data} = require '../src/recipe'


exports.test_get_recipe_data = (test) ->
    filename = "./test/fixtures/recipe_data.yaml"
    get_recipe_data filename, (err, recipe_data) ->
        test.ok "recipe" of recipe_data
        test.ok "bundles" of recipe_data
        test.ok "modules" of recipe_data
        test.done()
