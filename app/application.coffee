module.exports = class Application extends Chaplin.Application
  options:
    i18n: false
    routes: require 'routes'
    controllerSuffix: '_controller'

  constructor: (options) ->
    _.extend(@options, options)

    require 'lib/smart-navigate'

    global.View           = require 'lib/base/view'
    global.Controller     = require 'lib/base/controller'
    global.Model          = require 'lib/base/model'
    global.Collection     = require 'lib/base/collection'
    global.CollectionView = require 'lib/base/collection_view'
    global.Store          = Backbone.LocalStorage

    super @options