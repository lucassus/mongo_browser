module = angular.module("mb.controllers")

class AlertsController
  @$inject = ["$scope", "alerts"]
  constructor: (@$scope, @alerts) ->
    @$scope.alertMessages = @alerts.messages

    @$scope.disposeAlert = (id) =>
      @alerts.dispose(id)

module.controller "alerts", AlertsController
