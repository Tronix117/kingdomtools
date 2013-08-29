module.exports = class StaticView extends View

  className: 'static-view'

  constructor: (options) ->
    @[k] = v for k, v of options
    super
