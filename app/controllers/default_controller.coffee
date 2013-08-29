StaticView  = require 'views/pages/static'
ContactView = require 'views/pages/contact'
HomeView    = require 'views/pages/home'
LayoutView  = require 'views/layout'
HeaderView  = require 'views/layout/header'
FooterView  = require 'views/layout/footer'

module.exports = class StaticController extends Controller

  beforeAction: (params, route)->
    # We add/keep the main layout for this page
    @compose 'layout', LayoutView

    # We add/keep the header and refresh it when the route change
    @compose 'header', HeaderView, {region: 'header', routeName: route.name}
    
    # We add/keep the footer to this page
    @compose 'footer', FooterView, region: 'footer'

  home: ->
    @view = new HomeView region: 'main'

  about: ->
    @view = new StaticView
      region: 'main'
      template: require 'templates/pages/about'
      className: 'about-view'

  contact: ->
    @view = new ContactView region: 'main'