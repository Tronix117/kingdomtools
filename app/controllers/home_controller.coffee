HomeView = require 'views/home'

module.exports = class HomeController extends Controller

  show: ->
    @view = new HomeView