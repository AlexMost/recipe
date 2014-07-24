async = require 'async'
{read_yaml_file} = require './utils'
_ = require 'lodash'

parse_recipe = (filename, cb) ->
	async.waterfall([
		_.partial(read_yaml_file, filename)
		]
		cb
	)


module.exports = {parse_recipe}

