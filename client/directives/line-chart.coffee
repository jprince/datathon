datathon.directive 'lineChart', ->
  controller: ($scope) ->
    populations = [
      { id: 'line-pop-1', data: $scope.populationOne }
      { id: 'line-pop-2', data: $scope.populationTwo }
    ]

    _(populations).each (population) ->
      nv.addGraph ->
        chart = nv.models.lineChart().margin(left: 100).useInteractiveGuideline(true).showLegend(true).showYAxis(true).showXAxis(true)
        chart.xAxis.axisLabel('Time (ms)').tickFormat d3.format(',r')
        chart.yAxis.axisLabel('Voltage (v)').tickFormat d3.format('.02f')

        d3.select("##{population.id} svg").datum(population.data).call chart
        nv.utils.windowResize ->
          chart.update()
        chart
  restrict: 'E'
  scope:
    populationOne: '='
    populationTwo: '='
  template: "
    <div class='row'>
      <div id='line-pop-1' class='col s6'>
        <svg></svg>
      </div>
      <div id='line-pop-2' class='col s6'>
        <svg></svg>
      </div>
    </div>
  "
