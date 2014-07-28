async = require 'async'
_ = require 'lodash'


parse_bundle = (recipe, modules, bundle, cb) ->
    validate_bundle = ({name, bundle}, cb) ->
        if bundle.hasOwnProperty "modules"
            cb null, bundle
        else
            cb "Bundle #{name} has no modules section"

    async.waterfall([
        _.partial(bundle, validate_bundle)
        ]
        cb)


parse_bundles = (recipe, modules, cb) ->
    _bundles = ({name, modules} for name, bundle of recipe.bundles)
    _iterate_func = _.partial recipe, modules, parse_bundle
    async.map _bundles, _iterate_func, cb


module.exports = {parse_bundles}
