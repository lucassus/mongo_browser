module = angular.module("mb.controllers")

class AlertsController
  constructor: (@$scope, @alerts) ->
    @$scope.alertMessages = @alerts.messages

    @$scope.disposeAlert = (id) =>
      @alerts.dispose(id)

AlertsController.$inject = ["$scope", "alerts"]

module.controller "alerts", AlertsController
