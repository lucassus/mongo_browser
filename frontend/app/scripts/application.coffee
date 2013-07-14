# App Module
mb = angular.module "mb", [
  "ngSanitize",
  "mb.templates",
  "mb.resources", "mb.directives", "mb.filters", "mb.services",
  "mb.dialogs", "mb.pager", "mb.tableFilter", "mb.alerts", "mb.spinner"
]

mb.config [
  "$provide", "$httpProvider", "$routeProvider", "$locationProvider",
  ($provide, $httpProvider, $routeProvider, $locationProvider) ->

    # TODO temporary disable alerts disposing
    $provide.value("alertTimeout", null)

    $httpProvider.responseInterceptors.push("httpErrorsInterceptor")

    $routeProvider
      # Main page, list of all available databases
      .when "/",
          templateUrl: "templates/databases/index.html",
          controller: "databases.index"

      # Database stats
      .when "/databases/:dbName/stats",
        templateUrl: "templates/databases/stats.html",
        controller: "databases.stats"

      # List of collections for the given database
      .when "/databases/:dbName/collections",
          templateUrl: "templates/collections/index.html",
          controller: "collections.index"

      # Collection stats
      .when "/databases/:dbName/collections/:collectionName/stats",
        templateUrl: "templates/collections/stats.html",
        controller: "collections.stats",

      # List of documents for the given collection
      .when "/databases/:dbName/collections/:collectionName/documents",
          templateUrl: "templates/documents/index.html",
          controller: "documents.index",
          reloadOnSearch: false

      .when "/databases/:dbName/collections/:collectionName/documents/:id",
        templateUrl: "templates/documents/show.html",
        controller: "documents.show",

      # Information about the server
      .when "/server_info",
          templateUrl: "templates/server/show.html",
          controller: "servers.show"

      .otherwise(redirectTo: "/")

    $locationProvider.html5Mode(true)
]
