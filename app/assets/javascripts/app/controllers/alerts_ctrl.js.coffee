module = angular.module("mb.controllers", ["mb.services"])

module.controller "alerts", ($scope, alerts) ->
  $scope.alertMessages = alerts.messages

  $scope.disposeAlert = (id) ->
    alerts.dispose(id)
