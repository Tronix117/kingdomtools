LayoutView  = require 'views/layout'
HeaderView  = require 'views/layout/header'
FooterView  = require 'views/layout/footer'
TasksIndexView = require 'views/exemples/tasks/list'
tasks = require 'collections/tasks'

module.exports = class StaticController extends Controller

  beforeAction: (params, route)->
    @compose 'layout', LayoutView
    @compose 'header', HeaderView, {region: 'header', routeName: route.name}
    @compose 'footer', FooterView, region: 'footer'

    # Refresh tasks from database
    tasks.fetch()

  index: (params)->
    filterer = params.filterer?.trim() ? 'all'

    @view = new TasksIndexView 
      region: 'main'
      collection: tasks
      filterer: (model) ->
        switch filterer
          when 'completed' then model.get('completed')
          when 'active' then not model.get('completed')
          else true

  show: ->

  create: ->

  edit: ->