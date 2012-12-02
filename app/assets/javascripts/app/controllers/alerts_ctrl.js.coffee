@AlertsCtrl = ($scope, alerts) ->
  $scope.alertMessages = alerts.messages

  $scope.disposeAlert = (at) ->
    alerts.dispose(at)
