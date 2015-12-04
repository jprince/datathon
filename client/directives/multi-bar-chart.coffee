datathon.directive 'multiBarChart', ->
  controller: ($scope) ->
    populations = [
      { id: 'multi-bar-pop-1', data: $scope.populationOne }
      { id: 'multi-bar-pop-2', data: $scope.populationTwo }
    ]

    _(populations).each (population) ->
      nv.addGraph ->
        chart = nv.models.multiBarChart().reduceXTicks(true).rotateLabels(0).showControls(true).groupSpacing(0.1)
        chart.xAxis.tickFormat d3.format(',f')
        chart.yAxis.tickFormat d3.format(',.1f')
        d3.select("##{population.id} svg").datum(population.data).call chart
        nv.utils.windowResize chart.update
        chart

  restrict: 'E'
  scope:
    populationOne: '='
    populationTwo: '='
  template: "
    <div class='row'>
      <div id='multi-bar-pop-1' class='col s6'>
        <svg></svg>
      </div>
      <div id='multi-bar-pop-2' class='col s6'>
        <svg></svg>
      </div>
    </div>
  "
