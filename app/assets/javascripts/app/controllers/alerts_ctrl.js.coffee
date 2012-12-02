@AlertsCtrl = ($scope, alerts) ->
  $scope.alertMessages = alerts.messages

  $scope.disposeAlert = (id) ->
    alerts.dispose(id)
