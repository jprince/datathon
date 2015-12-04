datathon.directive 'linePlusBarChart', ->
  controller: ($scope) ->
    populations = [
      { id: 'line-plus-bar-pop-1', data: $scope.populationOne }
      { id: 'line-plus-bar-pop-2', data: $scope.populationTwo }
    ]

    _(populations).each (population) ->
      nv.addGraph ->
        data = population.data
        chart = nv.models.linePlusBarChart()
                            .margin(
                              top: 0
                              right: 10
                              bottom: 50
                              left: 70).x((d, i) ->
                              i
                            )
                            .height(250)
                            .y((d, i) ->
                              d[1]
                            )
        chart.xAxis.tickFormat (d) ->
          dx = data[0].values[d] and data[0].values[d][0] or 0
        chart.y1Axis.tickFormat d3.format(',f')
        chart.bars.forceY [ 0 ]
        chart.tooltipContent((key, x, y) ->
          "
            <div class='datathon-tooltip'>
              <h3>#{ x } yr(s) old</h3>
              <p>
                <span class='label'>BMI: </span>&nbsp;<span>#{ y }</span>
              </p>
            </div>
          "
        )
        d3.select("##{ population.id } svg").datum(data).transition().duration(0).call chart
        nv.utils.windowResize chart.update
        chart
  restrict: 'E'
  scope:
    label: '@'
    populationOne: '='
    populationTwo: '='
  template: "
    <div class='row valign-wrapper'>
      <div id='line-plus-bar-pop-1' class='col s5'>
        <svg></svg>
      </div>
      <div class='chart-label col s2 valign'><h5>{{ ::label }}</h5></div>
      <div id='line-plus-bar-pop-2' class='col s5'>
        <svg></svg>
      </div>
    </div>
  "
