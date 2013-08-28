LayoutView = require 'views/layout'

module.exports = class Controller extends Chaplin.Controller

  beforeAction: ->
    @compose 'layout', LayoutView