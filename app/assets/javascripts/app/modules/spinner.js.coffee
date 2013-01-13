spinner = angular.module("mb.spinner", [])

spinner.value "pendingRequests",
  counter: 0
  increment: -> @counter += 1
  decrement: -> if @isPending() then @counter -= 1
  isPending: -> @counter > 0

spinner.factory "pendingRequestsInterceptor", [
  "$injector", "$q", "pendingRequests", ($injector, $q, pendingRequests) ->
    (promise) ->
      $http = $injector.get("$http")

      onSuccess = (response) ->
        pendingRequests.decrement()
        response

      onError = (response) ->
        pendingRequests.decrement()
        $q.reject(response)

      promise.then(onSuccess, onError)
]

spinner.config [
  "$httpProvider", "pendingRequestsProvider", ($httpProvider, pendingRequestsProvider) ->
    # TODO use request interceptor
    pendingRequests = pendingRequestsProvider.$get()
    $httpProvider.defaults.transformRequest.push (data) ->
      pendingRequests.increment()
      data

    $httpProvider.responseInterceptors.push("pendingRequestsInterceptor")
]

class SpinnerController
  @$inject = ["$scope", "pendingRequests"]
  constructor: (@$scope, @pendingRequests) ->
    @$scope.showSpinner = @showSpinner

  showSpinner: =>
    @pendingRequests.isPending()

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
