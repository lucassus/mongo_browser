#= require app/services
#= require app/resources
#= require app/directives
#= require app/filters
#= require app/controllers
#= require_tree ./app/controllers

# App Module
angular.module("mb", ["mb.controllers", "mb.directives", "mb.filters"])
  .config [
    "$routeProvider", "$locationProvider", (route, location) ->
      route
        .when "/",
            templateUrl: "/ng/templates/databases.html",
            controller: "databases"

        .when "/server_info",
            templateUrl: "/ng/templates/server_info.html",
            controller: "serverInfo"

        .when "/databases/:dbName/collections",
            templateUrl: "/ng/templates/collections.html",
            controller: "collections"

        .when "/databases/:dbName/collections/:collectionName",
            templateUrl: "/ng/templates/documents.html",
            controller: "documents"

        .otherwise(redirectTo: "/")

      location.html5Mode(true)
  ]
