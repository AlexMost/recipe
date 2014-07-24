fs = require 'fs'
yaml = require 'js-yaml'

module.exports =
    read_yaml_file: (filename, cb) ->
        fs.readFile filename, "utf-8", (err, res) ->
            (cb err) if err
            yaml.loadAll res, (data) ->
                cb null, data