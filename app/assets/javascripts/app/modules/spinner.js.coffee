spinner = angular.module("mb.spinner", [])

spinner.factory "httpRequestTracker", [
  "$http", ($http) ->
    hasPendingRequests: ->
      $http.pendingRequests.length > 0
]

class SpinnerController
  @$inject = ["$scope", "httpRequestTracker"]
  constructor: (@$scope, @httpRequestTracker) ->
    @$scope.showSpinner = @showSpinner

  showSpinner: =>
    @httpRequestTracker.hasPendingRequests()

spinner.controller "spinner", SpinnerController

spinner.directive "spinner", ->
  replace: true
  restrict: "E"
  template: """
            <li class="spinner">
              <a href="#">
                <img ng-show="showSpinner()" src="/assets/ajax-loader.gif" />
              </a>
            </li>
            """
  controller: "spinner"
