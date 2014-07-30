fs = require 'fs'
yaml = require 'js-yaml'

module.exports =
    read_yaml_file: (filename, cb) ->
        fs.readFile filename, "utf-8", (err, res) ->
            if err
                return cb(
                    "Failed to open recipe file #{filename}")
            yaml.loadAll res, (data) ->
                cb null, data
