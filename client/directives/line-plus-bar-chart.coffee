datathon.directive 'linePlusBarChart', ->
  controller: ($scope) ->
    populations = [
      { id: 'line-plus-bar-pop-1', data: $scope.populationOne }
      { id: 'line-plus-bar-pop-2', data: $scope.populationTwo }
    ]

    _(populations).each (population) ->
      nv.addGraph ->
        data = population.data
        chart = nv.models.linePlusBarChart().margin(
          top: 30
          right: 60
          bottom: 50
          left: 70).x((d, i) ->
          i
        ).y((d, i) ->
          d[1]
        )
        chart.xAxis.tickFormat (d) ->
          dx = data[0].values[d] and data[0].values[d][0] or 0
          d3.time.format('%x') new Date(dx)
        chart.y1Axis.tickFormat d3.format(',f')
        chart.y2Axis.tickFormat (d) ->
          '$' + d3.format(',f')(d)
        chart.bars.forceY [ 0 ]
        d3.select("##{ population.id } svg").datum(data).transition().duration(0).call chart
        nv.utils.windowResize chart.update
        chart
  restrict: 'E'
  scope:
    populationOne: '='
    populationTwo: '='
  template: "
    <div class='row'>
      <div id='line-plus-bar-pop-1' class='col s6'>
        <svg></svg>
      </div>
      <div id='line-plus-bar-pop-2' class='col s6'>
        <svg></svg>
      </div>
    </div>
  "
