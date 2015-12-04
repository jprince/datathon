angular.module 'datathon', ['angular-meteor']
angular.module('datathon').controller 'ApplicationCtrl', [
  '$scope',
  ($scope) ->
    $scope.tasks = [
      { text: 'This is task 1' }
      { text: 'This is task 2' }
      { text: 'This is task 3' }
    ]
]
