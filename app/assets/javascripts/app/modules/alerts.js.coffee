alerts = angular.module("mb.alerts", [])

class AlertsController
  @$inject = ["$scope", "alerts"]
  constructor: (@$scope, @alerts) ->
    @$scope.alertMessages = @alerts.messages

    @$scope.disposeAlert = (id) =>
      @alerts.dispose(id)

alerts.controller "alerts", AlertsController

# TODO figure out how to create coffeescript class for services
alerts.factory "alerts", [
  "$log", "$timeout", "alertTimeout", ($log, $timeout, alertTimeout) ->
    lastId: 0
    messages: []

    # Returns a next id for the new message
    nextId: ->
      @lastId += 1

    push: (type, text) ->
      id = @nextId()
      $log.info("Alert [#{id}, #{type}]", text)

      @messages.push(id: id, type: type, text: text)
      @delayedDispose(id)

      id

    # Helper methods for various alerts types
    info: (text) -> @push("info", text)
    error: (text) -> @push("error", text)

    # Disposes a message with the given id
    dispose: (id) ->
      at = @messages.map((message) -> message.id).indexOf(id)
      @messages.splice(at, 1)

    # Dispose the message after the given time in milliseconds
    delayedDispose: (id) ->
      if alertTimeout? and alertTimeout > 0
        disposeTheAlert = =>
          $log.info("Disposing alert", id, "after", alertTimeout, "milliseconds")
          @dispose(id)
        $timeout(disposeTheAlert, alertTimeout)
]

alerts.directive "alerts", ->
  restrict: "E"
  transclude: true

  templateUrl: "/ng/templates/alerts.html"
  replace: true

  controller: "alerts"
