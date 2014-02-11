window.global = global = window

Application = require 'application'
routes = require 'routes'

# Initialize the application on DOM ready event.
$ ->
  # Mix in underscore.string into underscore
  #_.mixin _.str.exports()

  new Application