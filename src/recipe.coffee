Q = require 'q'
{parse_bundles} = require './bundles_parser'
{parse_recipe} = require './recipe_parser'
{parse_modules} = require './module_parser'
{dispatch_modules} = require './module_dispatcher'
{ModuleProtocol, ModuleAdapterProtocol, ModuleTypeError,
ModueAdapterTypeError} = require './module_protocol'


get_recipe_data = (filename, cb) ->
    {adapter} = require '../lib/module_types/single_cjs_module'

    q_recipe = Q.nfcall parse_recipe, filename

    q_rawModules = q_recipe.then (recipe) ->
        Q.nfcall parse_modules, recipe.modules

    q_modules = q_rawModules.then (modules) ->
        Q.nfcall dispatch_modules, modules, [adapter]

    q_bundles = Q.all([q_recipe, q_modules]).spread((recipe, modules) ->
        Q.nfcall parse_bundles, recipe, modules)

    Q.all([q_recipe, q_modules, q_bundles])
     .spread((recipe, modules, bundles) ->
         cb null, {recipe, modules, bundles})
     .catch(cb)


module.exports = {get_recipe_data, ModuleProtocol,
    ModuleAdapterProtocol, ModuleTypeError, ModueAdapterTypeError}
