datathon.directive 'linePlusBarChart', ->
  controller: [ '$scope', ($scope) ->
    populations = [
      { id: 'line-plus-bar-pop-1', data: $scope.populationOne }
      { id: 'line-plus-bar-pop-2', data: $scope.populationTwo }
    ]

    _(populations).each (population) ->
      nv.addGraph ->
        chart = nv.models.linePlusBarChart()
                            .margin({ top: 0, right: 10, bottom: 0, left: 30 })
                            .height(250)
                            .x((d, i) -> i)
                            .y((d, i) -> d[1])
                            .options({ focusEnable: false })
        chart.bars.forceY [ 0, 50 ]
        chart.tooltipContent((key, x, y) ->
          "
            <div class='datathon-tooltip'>
              <h3>#{ x } yr(s) old</h3>
              <p>
                <span class='label'>BMI: </span>&nbsp;<span>#{ y.toFixed(2) }</span>
              </p>
            </div>
          "
        )
        d3.select("##{ population.id } svg").datum(population.data).transition().duration(0).call chart
          .select('.nv-y2.nv-axis').remove();
        nv.utils.windowResize chart.update
        chart
  ]
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
