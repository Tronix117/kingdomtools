sysPath = require 'path'

production = process.env.BRUNCH_ENV is 'production'

# See http://brunch.io/#documentation for docs.
exports.config =
  # Let's minify everything when production
  optimize: production

  # Like to get notifications if available
  notifications: true

  # Where to make the magic !
  #paths:
  #  public: 'public'

  files:
    javascripts:
      joinTo: 
        # Better two have app.js AND vendor.js for caching reasons (vendor is not updated as often)
        'js/app.js': /^(app)/
        'js/vendor.js': /^(vendor|bower_components)/
    stylesheets:
      joinTo: 'css/app.css'
    templates:
      joinTo: 'js/app.js'

  conventions:
    # Ignore files finishing by .dev.* or .prod.* depending on the env
    # Ignore files with filename starting by `_` or in a (sub)directory
    # with name starting by `_`
    ignored: (path) ->
      (basename = sysPath.basename path)[0] is '_' or
      /(^|\/)_.*/.test(sysPath.dirname path) or
      (production and /.*\.dev\..*$/ or /.*\.prod\..*$/).test(basename)
    assets: /(assets|font)/

  # Little hack to fix some issues stylus have with size of images + Debug
  plugins:
    stylus:
      paths: ['app/assets/images']

    # Some conventions to keep code clean
    coffeelint:
      pattern: /^app\/.*\.coffee$/
      options:
        no_trailing_semicolons:
          level: "ignore"
        max_line_length:
          level: "ignore"
        no_trailing_whitespace:
          level: "warn"
        no_backticks:
          level: "warn"
        indentation:
          value: 2
          level: "error"

        max_line_length:
          value: 80
          level: "warn"

  # AutoReload should not be enabled in production
  autoReload:
    enabled: not production
