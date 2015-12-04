@datathon = angular.module 'datathon', ['angular-meteor']
datathon.controller 'ApplicationCtrl', [
  '$scope'
  '$http',
  ($scope, $http) ->
    $scope.tasks = [
      { text: 'This is task 1' }
      { text: 'This is task 2' }
      { text: 'This is task 3' }
    ]

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

    $http.get('ed-visits-data-1.json').then (response) ->
      edVisitsDataPop1 = response.data
      $http.get('preventive-visits-data-1.json').then (response) ->
        preventiveVisitsDataPop1 = response.data
        $scope.visitPop1 = formatMultiBarData("ED", "#7cbf4c", edVisitsDataPop1).concat(formatMultiBarData("Preventive", "#31849a", preventiveVisitsDataPop1))
        $http.get('ed-visits-data-2.json').then (response) ->
          edVisitsDataPop2 = response.data
          $http.get('preventive-visits-data-2.json').then (response) ->
            preventiveVisitsDataPop2 = response.data
            $scope.visitPop2 = formatMultiBarData("ED", "#7cbf4c", edVisitsDataPop2).concat(formatMultiBarData("Preventive", "#31849a", preventiveVisitsDataPop2))
      $http.get('bp-systolic-data-1.json').then (response) ->
        BPSystolicPop1 = response.data
        $http.get('bp-diastolic-data-1.json').then (response) ->
          BPDiastolicPop1 = response.data
          $scope.BPPop1 = formatLineChartData('Systolic', '#e68a00', BPSystolicPop1).concat(formatLineChartData('Diastolic', '#e44145', BPDiastolicPop1))
          $http.get('bp-systolic-data-2.json').then (response) ->
            BPSystolicPop2 = response.data
            $http.get('bp-diastolic-data-2.json').then (response) ->
              BPDiastolicPop2 = response.data
              $scope.BPPop2 = formatLineChartData('Systolic', '#e68a00', BPSystolicPop2).concat(formatLineChartData('Diastolic', '#e44145', BPDiastolicPop2))
              $scope.loaded = true
]
