module.exports = class HeaderView extends View
  template: require 'templates/layout/header'

  initialize: (params)->
    super
    @routeName = params.routeName

  render: ->
    super

    @$("[data-route-name*=\"#{@routeName}\"]").addClass('active')