StaticView = require 'views/static'

module.exports = class StaticController extends Controller

  about: ->
    @view = new StaticView
      template: require 'templates/about'
      className: 'about-view'