datathon.directive 'lineChart', ->
  controller: ($scope) ->
    populations = [
      { id: 'line-pop-1', data: $scope.populationOne }
      { id: 'line-pop-2', data: $scope.populationTwo }
    ]

    _(populations).each (population) ->
      nv.addGraph ->
        chart = nv.models.lineChart()
                            .margin(left: 10)
                            .useInteractiveGuideline(true)
                            .showLegend(true)
                            .showYAxis(false)
                            .showXAxis(true)
                            .height(250)
        chart.yAxis.axisLabel('mmHg').tickFormat d3.format('.02f')
        chart.interactiveLayer.tooltip.contentGenerator((data) ->
          "
            <div class='datathon-tooltip'>
              <h3>#{ data.value } yr(s) old</h3>
              <p>
                <span class='label'>#{ data.series[0].key }: </span>&nbsp;<span>#{ data.series[0].value }</span><br/>
                <span class='label'>#{ data.series[1].key }: </span>&nbsp;<span>#{ data.series[1].value }</span>
              </p>
            </div>
          "
        )
        population.data.forEach (d) -> d.values.forEach (d) -> d.x = +d.x
        chartElem = d3.select("##{population.id} svg").datum(population.data).call chart
        nv.utils.windowResize ->
          chart.update()
        chart
  restrict: 'E'
  scope:
    label: '@'
    populationOne: '='
    populationTwo: '='
  template: "
    <div class='row valign-wrapper'>
      <div id='line-pop-1' class='col s5'>
        <svg></svg>
      </div>
      <div class='chart-label col s2 valign'><h5>{{ ::label }}</h5></div>
      <div id='line-pop-2' class='col s5'>
        <svg></svg>
      </div>
    </div>
  "
