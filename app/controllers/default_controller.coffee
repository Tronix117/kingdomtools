StaticView  = require 'views/pages/static'
HomeView    = require 'views/pages/home'
LayoutView  = require 'views/layout'
HeaderView  = require 'views/layout/header'
FooterView  = require 'views/layout/footer'

module.exports = class StaticController extends Controller

  beforeAction: (params, route)->
    # We add/keep the main layout for this page
    @reuse 'layout', LayoutView

    # We add/keep the header and refresh it when the route change
    @reuse 'header', HeaderView, {region: 'header', routeName: route.name}
    
    # We add/keep the footer to this page
    @reuse 'footer', FooterView, region: 'footer'

  home: ->
    @view = new HomeView region: 'main'

  about: ->
    @view = new StaticView
      region: 'main'
      template: require 'templates/pages/about'
      className: 'about-view'