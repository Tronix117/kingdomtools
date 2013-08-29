LayoutView  = require 'views/layout'
HeaderView  = require 'views/layout/header'
FooterView  = require 'views/layout/footer'
ContactView = require 'views/pages/contact'
TaskCollection = require 'collections/exemples/tasks'

module.exports = class StaticController extends Controller

  beforeAction: (params, route)->
    @compose 'layout', LayoutView
    @compose 'header', HeaderView, {region: 'header', routeName: route.name}
    @compose 'footer', FooterView, region: 'footer'

  index: ->
    @collection = TaskCollection
    @view = new TaskView region: 'main'

  show: ->

  create: ->

  edit: ->