@datathon = angular.module 'datathon', ['angular-meteor']
datathon.controller 'ApplicationCtrl', [
  '$http',
  '$q',
  '$scope',
  ($http, $q, $scope) ->
    calculateWeightedAverage = (data) ->
      values = []
      ages = _((data).map (row) -> row.age).uniq()
      _(ages).each (age) ->
        ageData = _(data).filter (row) -> row.age is age
        totalValue = _(ageData).reduce ((memo, row) ->
          memo += row.value * row.number
        ), 0
        totalNumber = _(ageData).reduce ((memo, row) ->
          memo += row.number
        ), 0
        row =
          "x": age
          "y": totalValue / totalNumber

        values.push row
      values

    formatLineChartData = (key, color, data) ->
      weightedAverageData = calculateWeightedAverage(data)
      [ { "values": weightedAverageData, "key": key, "color": color } ]

    formatLinePlusBarChartData = (color, data) ->
      weightedAverageData = _calculateWeightedAverage(data)
      values = [
        _(calculateWeightedAverage(data)).map (row) -> [ parseInt(row.x) , row.y ]
      ]

      [
        {
          "key" : "Actual" ,
          "bar": true,
          "color": color,
          "values" : values
        } ,
        {
          "key" : "Expected" ,
          "color" : "#fece34",
          "values" : [ [ 0 , 20 ] , [ 100, 20 ] ]
        }
      ]

    formatMultiBarData = (key, color, data) ->
      weightedAverageData = calculateWeightedAverage(data)
      [ { "key": key, "color": color, "values": _(weightedAverageData).sortBy (row) -> parseInt(row.x) } ]

    # $scope.BMIPop1 = formatLinePlusBarChartData("#c456a0", BMIDataPop1)
    # $scope.BMIPop2 = formatLinePlusBarChartData("#c456a0", BMIDataPop2)

    BPChartLoaded = $q.defer()
    visitChartLoaded = $q.defer()

    loadBPChartData = ->
      Systolic1 = $http.get('bp-systolic-data-1.json').then (response) -> response.data
      Diastolic1 = $http.get('bp-diastolic-data-1.json').then (response) -> response.data
      Systolic2 = $http.get('bp-systolic-data-2.json').then (response) -> response.data
      Diastolic2 = $http.get('bp-diastolic-data-2.json').then (response) -> response.data
      $q.all([Systolic1, Diastolic1, Systolic2, Diastolic2]).then (BPData) ->
        $scope.BPPop1 = formatLineChartData('Systolic', '#e68a00', BPData[0]).concat(formatLineChartData('Diastolic', '#e44145', BPData[1]))
        $scope.BPPop2 = formatLineChartData('Systolic', '#e68a00', BPData[2]).concat(formatLineChartData('Diastolic', '#e44145', BPData[3]))
        BPChartLoaded.resolve()

    loadVisitChartData = ->
      ED1 = $http.get('ed-visits-data-1.json').then (response) -> response.data
      preventive1 = $http.get('preventive-visits-data-1.json').then (response) -> response.data
      ED2 = $http.get('ed-visits-data-2.json').then (response) -> response.data
      preventive2 = $http.get('preventive-visits-data-2.json').then (response) -> response.data
      $q.all([ED1, preventive1, ED2, preventive2]).then (visitData) ->
        $scope.visitPop1 = formatMultiBarData("ED", "#7cbf4c", visitData[0]).concat(formatMultiBarData("Preventive", "#31849a", visitData[1]))
        $scope.visitPop2 = formatMultiBarData("ED", "#7cbf4c", visitData[2]).concat(formatMultiBarData("Preventive", "#31849a", visitData[3]))
        visitChartLoaded.resolve()

    $q.all([BPChartLoaded.promise, visitChartLoaded.promise]).then ->
      $scope.dataLoaded = true

    loadBPChartData()
    loadVisitChartData()
]
