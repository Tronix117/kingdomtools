module.exports = class ScoreView extends View
  className: 'score-view'
  template: require 'templates/score'

  events: 
    'change input': 'changeAction'
    'change select': 'changeAction'

  changeAction: (e)->
    $$ = $ e.target
    @[$$.attr 'name' ] = parseInt($$.val()) or 0
    
    @computeScore()

  computeScore: ->
    @result = Math.round((@titre or 0) * 100 * (@carte or 1) + (@armee or 0) / 3 + (@gloire or 0) * 2 + (@reputation or 0) * 3)

    @showResults()

  showResults: ->
    @$('#result').html "Votre score sera de #{@result} à votre mort."