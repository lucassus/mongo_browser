module = angular.module("mb.services", [])

module.factory "httpErrorsInterceptor", [
  "$injector", "$q", "alerts", ($injector, $q, alerts) ->
    (promise) ->
      $http = $injector.get("$http")

      onError = (response) ->
        errorMessage = response.data?.error || "Unexpected HTTP error"
        alerts.error(errorMessage)
        $q.reject(response)

      promise.then(null, onError)
]
