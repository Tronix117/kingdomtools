###
# I18n class
# Allow you to add Internationalization to your CoffeeScript application
#
# Just call it with a `require 'util/I18n'` or `new I18n` if you don't have a `require` system
# More informations here: https://github.com/Tronix117/tradify
# Translation files should be saved in `locales/{langage code}.coffee`
#
# Then you can translate everything with `tr('{0} day', numberOfDay)`
#
# @author Jeremy Trufier <jeremy@trufier.com>
###

class I18n

  constructor: ->
    @locale = 'en'
    @translations = []

    window.tr = @tr
    window.getLanguageCode = @getLanguageCode

    code = @getLanguageCode()

    pf = [
      code.language + '-' + code.region
      code.language + '-' + code.region.toUpperCase()
      code.language + '_' + code.region
      code.language + '_' + code.region.toUpperCase()
      code.language
      code.language.toUpperCase()
      code.region
      code.region.toUpperCase()
      @locale
    ]

    while pf.length and not @translations.length
      try @translations = require('locales/'+pf.shift()) catch e

    @

  getLanguageCode: ->
    lang = (window.navigator.userLanguage || window.navigator.language || 'en').toLowerCase().match(/(\w\w)[-_]?(\w\w)?/)
    { language: lang[1], region: lang[2] || lang[1] }

  # i18n
  # How is it working ?
  #
  # tr(string, arg1, arg2, ...)
  #
  # Inside the first argument, to write some arguments the format is:
  # {0} -> write arguments 1
  # {1} -> write arguments 2
  # ...
  # {0s} -> translator help: type, can be: s(tring), i(nteger), f(loat), d(ate)
  # {0#Date field} -> Comment for the translator
  # {0i#Number} -> guess !
  tr: (s)=>
    try
      t = @translations[s] = [].concat(@translations[s] || [])

      a = arguments
      i = 0
      while i < t.length
        s = if typeof t[i] is "function" then t[i].apply(this, a) else t[i]
        i += 1
      return s.replace /{(\d+)\w?(#.*?)?}/g, (n, c) ->
        a[c]  if a[c = parseInt(c) + 1]
    catch e
      console.error(s, e.message)
      return s

module.exports = new I18n