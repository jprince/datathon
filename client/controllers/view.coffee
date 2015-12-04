@datathon = angular.module 'datathon', ['angular-meteor']
datathon.controller 'ApplicationCtrl', [
  '$scope',
  ($scope) ->
    $scope.tasks = [
      { text: 'This is task 1' }
      { text: 'This is task 2' }
      { text: 'This is task 3' }
    ]

    data = myData

    nv.addGraph ->
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
      d3.select('#chart svg').datum(data).transition().duration(0).call chart
      nv.utils.windowResize chart.update
      chart
]
