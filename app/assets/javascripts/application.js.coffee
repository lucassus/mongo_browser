#= require app

# App Module
requires = [
  "bootstrap", "ngSanitize",
  "mb.controllers", "mb.directives", "mb.filters",
  "mb.dialogs", "mb.pager", "mb.tableFilter", "mb.alerts", "mb.spinner"]

angular.module("mb", requires)
  .config [
    "$provide", "$httpProvider", "$routeProvider", "$locationProvider",
    ($provide, $httpProvider, $routeProvider, $locationProvider) ->
      $provide.value("alertTimeout", 3000)

      httpErrorsInterceptor = ($q, $log, alerts) ->
        (promise) ->
          onSuccess = (response) ->
            $log.info("Http response:",response)
            response

          onError = (response) ->
            $log.info("HTTP error", response)
            alerts.push("error", "HTTP error")
            $q.reject(response)

          promise.then(onSuccess, onError)
      httpErrorsInterceptor.$inject = ["$q", "$log", "alerts"]

      $httpProvider.responseInterceptors.push(httpErrorsInterceptor)

      $routeProvider
        # Main page, list of all available databases
        .when "/",
            templateUrl: "/ng/templates/databases.html",
            controller: "databases"

        # List of collections for the given database
        .when "/databases/:dbName/collections",
            templateUrl: "/ng/templates/collections.html",
            controller: "collections"

        # list of documents for the given collection
        .when "/databases/:dbName/collections/:collectionName/documents",
            templateUrl: "/ng/templates/documents.html",
            controller: "documents",
            reloadOnSearch: false

        # Information about the server
        .when "/server_info",
            templateUrl: "/ng/templates/server_info.html",
            controller: "serverInfo"

        .otherwise(redirectTo: "/")

      $locationProvider.html5Mode(true)
  ]
