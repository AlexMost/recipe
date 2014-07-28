async = require 'async'
_ = require 'lodash'


parse_bundle = (recipe, modules, bundle, cb) ->
    validate_bundle = ({name, bundle}, cb) ->
        if bundle.hasOwnProperty "modules"
            cb null, bundle
        else
            cb "Bundle #{name} has no modules section"
    async.waterfall [(_.partial validate_bundle, bundle)], cb


parse_bundles = (recipe, mods, cb) ->
    _bundles = ({name:n, bundle} for n, bundle of recipe.bundles)
    _iterate_func = _.partial parse_bundle, recipe, mods
    async.map _bundles, _iterate_func, cb


module.exports = {parse_bundles}
