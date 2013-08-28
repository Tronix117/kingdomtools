module.exports = class Application extends Chaplin.Application
  options:
    i18n: false
    routes: require 'routes'
    controllerSuffix: '_controller'

  constructor: (options) ->
    _.extend(@options, options)

    require 'lib/i18n' if @options.i18n

    super @options