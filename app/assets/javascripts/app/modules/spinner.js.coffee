spinner = angular.module("mb.spinner", [])

# TODO refactor this, create service?
spinner.config [
  "$httpProvider",
  ($httpProvider) ->
    pendingRequests = 0

    showSpinner = (data) ->
      pendingRequests += 1
      $scope = angular.element("li.spinner").scope()
      $scope.pendingRequests = pendingRequests if $scope
      data

    $httpProvider.defaults.transformRequest.push(showSpinner)

    httpSpinnerInterceptor = ($q) ->
      hideSpinner = ->
        pendingRequests -= 1
        $scope = angular.element("li.spinner").scope()
        $scope.pendingRequests = pendingRequests if $scope

      (promise) ->
        onSuccess = (response) ->
          hideSpinner()
          response

        onError = (response) ->
          hideSpinner()
          $q.reject(response)

        promise.then(onSuccess, onError)
    httpSpinnerInterceptor.$inject = ["$q", "$rootScope"]

    $httpProvider.responseInterceptors.push(httpSpinnerInterceptor)
]

class SpinnerController
  @$inject = ["$scope"]
  constructor: (@$scope) ->
    $scope.pendingRequests = 0
    @$scope.showSpinner = @showSpinner

  showSpinner: =>
    @$scope.pendingRequests > 0

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
