{get_recipe_data} = require '../src/recipe'


exports.test_get_recipe_data = (test) ->
    filename = "./test/fixtures/recipe_data.yaml"
    get_recipe_data filename, (err, recipe_data) ->
        test.ok !err, err
        test.ok "recipe" of recipe_data
        test.ok "bundles" of recipe_data
        test.ok "modules" of recipe_data
        test.ok(
            (recipe_data.bundles.length is 1)
            "must be 1 bundle")
        test.done()
