#= require app

# App Module
requires = [
  "ngSanitize",
  "mb.controllers", "mb.directives", "mb.filters",
  "mb.dialogs", "mb.pager", "mb.tableFilter", "mb.alerts", "mb.spinner"]

angular.module("mb", requires)
  .config [
    "$provide", "$httpProvider", "$routeProvider", "$locationProvider",
    ($provide, $httpProvider, $routeProvider, $locationProvider) ->
      $provide.value("alertTimeout", 3000)

      # TODO refactor this interceptor, see spinner
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
            templateUrl: "/ng/templates/databases/index.html",
            controller: "databases.index"

        # Database stats
        .when "/databases/:dbName/stats",
          templateUrl: "/ng/templates/databases/stats.html",
          controller: "databases.stats"

        # List of collections for the given database
        .when "/databases/:dbName/collections",
            templateUrl: "/ng/templates/collections/index.html",
            controller: "collections.index"

        # Collection stats
        .when "/databases/:dbName/collections/:collectionName/stats",
          templateUrl: "/ng/templates/collections/stats.html",
          controller: "collections.stats",

        # List of documents for the given collection
        .when "/databases/:dbName/collections/:collectionName/documents",
            templateUrl: "/ng/templates/documents/index.html",
            controller: "documents.index",
            reloadOnSearch: false

        .when "/databases/:dbName/collections/:collectionName/documents/:id",
          templateUrl: "/ng/templates/documents/show.html",
          controller: "documents.show",

        # Information about the server
        .when "/server_info",
            templateUrl: "/ng/templates/server/show.html",
            controller: "servers.show"

        .otherwise(redirectTo: "/")

      $locationProvider.html5Mode(true)
  ]
