{parse_recipe} = require '../src/recipe_parser'

exports.can_read_recipe = (test) ->
	filepath = './test/fixtures/test_recipe_read.yaml'
	parse_recipe filepath, (err, cb) ->
		test.ok !err
		test.done()