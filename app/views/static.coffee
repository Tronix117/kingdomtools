module.exports = class StaticView extends View

  className: 'static-view'
  container: 'body'
  region: 'main'

  constructor: (options) ->
    @[k] = v for k, v of options
    super
