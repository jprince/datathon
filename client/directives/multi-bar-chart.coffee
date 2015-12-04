datathon.directive 'multiBarChart', ->
  controller: ($scope) ->
    populations = [
      { id: 'multi-bar-pop-1', data: $scope.populationOne }
      { id: 'multi-bar-pop-2', data: $scope.populationTwo }
    ]

    _(populations).each (population) ->
      nv.addGraph ->
        chart = nv.models.multiBarChart()
                           .reduceXTicks(true)
                           .rotateLabels(0)
                           .showControls(true)
                           .groupSpacing(0.1)
                           .height(250)
        chart.xAxis.tickFormat d3.format(',f')
        chart.yAxis.tickFormat d3.format(',.1f')
        chart.tooltipContent((key, x, y) ->
          "
            <div class='datathon-tooltip'>
              <h3>#{ x } yr(s) old</h3>
              <p>
                <span class='label'>#{ key }: </span>&nbsp;<span>#{ y }</span>
              </p>
            </div>
          "
        )
        chartElem = d3.select("##{population.id} svg").datum(population.data).call chart
        chartElem.select('g').attr('transform', 'translate(60, 55)')
        nv.utils.windowResize chart.update
        chart

  restrict: 'E'
  scope:
    label: '@'
    populationOne: '='
    populationTwo: '='
  template: "
    <div class='row valign-wrapper'>
      <div id='multi-bar-pop-1' class='col s5'>
        <svg></svg>
      </div>
      <div class='chart-label col s2 valign'><h5>{{ ::label }}</h5></div>
      <div id='multi-bar-pop-2' class='col s5 valign'>
        <svg></svg>
      </div>
    </div>
  "
