module.exports = class CommerceView extends View
  className: 'commerce-view'
  template: require 'templates/commerce'

  events: 
    'change input': 'changeAction'

  initialize: ->
    super
    @garnison = 0
    @commerce = 0
    @tours = 0
    @wantedCommerce = 0

  changeAction: (e)->
    $$ = $ e.target
    @[$$.attr 'name' ] = parseInt($$.val()) or 0
    @compute()

  showResults: ->
    $result = $('#result')
      .html('')
      .append("Rentable après : #{@results.rentableTrigger} tours<br />")

    if @results.wantedCommerceTrigger is null
      $result.append "Impossible d'atteindre #{@wantedCommerce} de commerce avec cette garnison."
    else
      $result.append("#{@wantedCommerce} de commerce après : #{@results.wantedCommerceTrigger} tours")

  compute: ->
    @results = {}

    datas = [
      C: @commerce
      S: @garnison
      T: 0
      a: 0
      nT: 0
    ]
    
    @results.rentableTrigger = if @commerce >= @garnison then 0 else null
    @results.wantedCommerceTrigger = if @commerce >= @wantedCommerce then 0 else null

    while (d = @computeStep(datas)).C <= @garnison || datas.length <= @tours || (d.C <= @wantedCommerce and @garnison * 2 > @wantedCommerce)
      @results.rentableTrigger = datas.length - 1 if @results.rentableTrigger is null && d.C >= @garnison
      @results.wantedCommerceTrigger = datas.length - 1 if @results.wantedCommerceTrigger is null && d.C >= @wantedCommerce
      datas.push d

    @results.datas = datas
    @showResults()

  computeStep: (datas)->
    n = datas.length
    prev = datas[datas.length - 1]
    cur =
      C: prev.C + prev.a
      S: prev.S
    
    cur.T = prev.T + cur.S - prev.nT

    if cur.C >= 0
      cur.T -= Math.floor cur.C / 2
      cur.a = Math.floor cur.T / (10 * cur.C + 10)
      cur.nT = cur.a * (10 * cur.C + 5 * cur.a + 5)
    else
      cur.a = - Math.floor cur.T / (10 * cur.C)
      cur.nT = - cur.a * (10 * cur.C + 5 * cur.a - 5)

    cur
