window.global = global = window

Application = require 'application'
routes = require 'routes'

# Initialize the application on DOM ready event.
$ ->
  # Mix in underscore.string into underscore
  _.mixin _.str.exports()

  global.View = require 'lib/base/view'
  global.Controller = require 'lib/base/controller'
  global.Model = require 'lib/base/model'
  global.Collection = require 'lib/base/collection'
  global.CollectionView = require 'lib/base/collection_view'

  new Application