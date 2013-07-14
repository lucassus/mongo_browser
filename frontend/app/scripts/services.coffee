module = angular.module("mb.services", [])

# Intercepts all HTTP errors and dislays a flash message
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
