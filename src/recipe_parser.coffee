async = require 'async'
path = require 'path'
{read_yaml_file} = require './utils'
_ = require 'lodash'


parse_recipe = (filename, cb) ->
    ###
    Function for reading, parsing and validating recipe
    data structure.
    ###

    async.waterfall(
        [
            _.partial(read_yaml_file, filename)
            freeze_recipe
            validate_recipe_structure
        ]
        cb)


freeze_recipe = (recipe, cb) -> cb null, Object.freeze(recipe)


validate_recipe_structure = (recipe, validate_cb) ->
    
    must_have_bundles_or_realms_section = (recipe, cb) ->
        
        has_bundles_section = recipe.hasOwnProperty "bundles"
        has_realm_section = recipe.hasOwnProperty "realm"
        unless has_bundles_section or has_realm_section
            # TODO: paste link to documentation here
            cb "recipe must have realm or bundles section "
        else
            cb null, recipe

    must_have_modules_section = (recipe, cb) ->
        unless recipe.hasOwnProperty "modules"
            # TODO: paste link to documentation here
            cb "recipe must have modules section "
        else
            cb null, recipe

    must_have_abstract_section = (recipe, cb) ->
        unless recipe.hasOwnProperty "abstract"
            # TODO: paste link to documentation here
            cb "recipe must have abstract section"
        else
            cb null, recipe

    must_have_version = (recipe, cb) ->
        unless recipe.abstract.hasOwnProperty "version"
            # TODO: paste link to documentation here
            cb "recipe abstract section must have version attribute"
        else
            cb null, recipe

    abstract_section_must_be_integer = (recipe, cb) ->
        unless _.isNumber recipe.abstract.version
            # TODO: paste link to documentation here
            cb "recipe version must be a number"
        else
            cb null, recipe

    async.waterfall(
        [
           _.partial(must_have_bundles_or_realms_section, recipe)
           must_have_modules_section
           must_have_abstract_section
           must_have_version
           abstract_section_must_be_integer
        ]
        validate_cb
    )


module.exports = {parse_recipe, validate_recipe_structure}

