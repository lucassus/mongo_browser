module = angular.module("mb.services", [])

module.factory "httpErrorsInterceptor", [
  "$injector", "$q", "alerts", ($injector, $q, alerts) ->
    (promise) ->
      $http = $injector.get("$http")

      onError = (response) ->
        alerts.push("error", "HTTP error")
        $q.reject(response)

      promise.then(null, onError)
]
