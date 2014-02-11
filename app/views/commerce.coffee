module.exports = class CommerceView extends View
  className: 'commerce-view'
  template: require 'templates/commerce'

  events: 
    'change input': 'changeAction'
    'change select': 'changeAction'

  initialize: ->
    super
    @garnison = 10
    @commerce = -16
    @tours = 0
    @wantedCommerce = 19

  render: ->
    super

    @chart = global.chart = new Highcharts.Chart({
      chart:
        type: 'areaspline'
        renderTo: @$('#chart').get(0)
        width: 600
        height: 400
      credits: enabled: false
      exporting: enabled: false
      title:
        text: 'Évolution du commerce'
      xAxis:
        title:
          text: 'Nombre de tour'
      yAxis:
        title:
          text: 'Commerce par tour'
      series: [
        name: 'Commerce négatif'
        color: '#E74C3C'
        negativeColor: '#E74C3C'
      ,
        name: 'Commerce positif'
        color: '#3498DB'
      ,
        name: 'Commerce rentable'
        color: '#2ECC71'
      ]
      plotOptions:
        areaspline:
          fillOpacity: 0.5
          tooltip:
            pointFormat: '<span style="color:{series.color}">{series.name} :</span> <b>{point.y}</b><br/>'
            headerFormat: '<span>après {point.key} tours</span><br/>'
    })

    #@compute()

  changeAction: (e)->
    $$ = $ e.target
    @[$$.attr 'name' ] = parseInt($$.val()) or 0
    @compute()

  showResults: ->
    $result = @$('#result')
      .html('')
      .append("Rentable après : #{@results.rentableTrigger} tours<br />")

    if @results.wantedCommerceTrigger is null
      $result.append "Impossible d'atteindre #{@wantedCommerce} de commerce avec cette garnison."
    else
      $result.append("#{@wantedCommerce} de commerce après : #{@results.wantedCommerceTrigger} tours")

    serie = []
    serieRentable = []
    serieNegative = []

    for d, i in @results.datas
      if i > 0 &&@results.datas[i-1].C != d.C
        if d.C < 0
          serieNegative.push [i, d.C]
        else if d.C < d.S
          serie.push [i,d.C]
        else
          serieRentable.push [i,d.C]
          serie.push serieRentable[0]if serieRentable.length is 1

    @chart.series[0].setData serieNegative
    @chart.series[1].setData serie
    @chart.series[2].setData serieRentable

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

    i = 0
    while i < 10000 and (d = @computeStep(datas)).C <= @garnison || datas.length <= @tours || (d.C <= @wantedCommerce and @garnison * 2 > @wantedCommerce)
      @results.rentableTrigger = datas.length - 1 if @results.rentableTrigger is null && d.C >= @garnison
      @results.wantedCommerceTrigger = datas.length - 1 if @results.wantedCommerceTrigger is null && d.C >= @wantedCommerce
      datas.push d
      i++

    @results.datas = datas
    @showResults()

  computeStep2: (datas)->
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

  computeStep3: (datas)->
    n = datas.length
    prev = datas[datas.length - 1]
    cur =
      S: prev.S
    
    if prev.S < prev.C / 2
      cur.T = prev.T - Math.pow(prev.C / 2 - prev.S, 2)
    else if prev.C < 0
      cur.T = prev.T + prev.S
    else
      cur.T = prev.T + prev.S - prev.C / 2

    cur.C = @commerce + Math.floor(cur.T / 10)

    cur

  computeStep: (datas)->
    # Si le commerce est strictement négatif (C<0), le compteur augmente de S à chaque tour. Lorsque que le compteur atteint ou dépasse -10*C, on lui retranche -10*C puis le commerce augmente de 1. Ainsi, il faut environ attendre 10*C/S tours pour que le commerce augmente de 1.

    # Si le commerce est positif ou nul (C>=0), le compteur augmente de S-C/2 (arrondi à l'inférieur) à chaque tour. Lorsque que le compteur atteint ou dépasse 10*C+10, on lui retranche 10*C+10 puis le commerce augmente de 1. Ainsi, il faut environ attendre 10*C/(S-C/2) tours pour que le commerce augmente de 1.

    n = datas.length
    prev = datas[datas.length - 1]
    cur =
      S: prev.S
      C: prev.C
      T: prev.T
    
    # Decrease
    if prev.S < prev.C / 2
      cur.T -= Math.pow(prev.C / 2 - prev.S, 2)

    # Negative increase
    else if prev.C < 0
      cur.T += prev.S

    # Positive increase
    else
      cur.T += prev.S - Math.floor(prev.C / 2)

    while cur.T >= 10 * Math.abs(cur.C) + (if cur.C >= 0 then 10 else 0)
      cur.T -= 10 * Math.abs(cur.C) + (if cur.C >= 0 then 10 else 0)
      cur.C += 1

    cur