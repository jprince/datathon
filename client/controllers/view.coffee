@datathon = angular.module 'datathon', ['angular-meteor']
datathon.controller 'ApplicationCtrl', [
  '$scope',
  ($scope) ->
    $scope.tasks = [
      { text: 'This is task 1' }
      { text: 'This is task 2' }
      { text: 'This is task 3' }
    ]

    $scope.BMIPop1 = linePlusBarData
    $scope.BMIPop2 = linePlusBarData

    $scope.visitPop1 = multiBarData
    $scope.visitPop2 = multiBarData

    $scope.BPPop1 = lineData
    $scope.BPPop2 = lineData
]
