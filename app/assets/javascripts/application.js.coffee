#= require app/services
#= require app/resources
#= require app/directives
#= require app/filters
#= require app/pager
#= require app/controllers
#= require_tree ./app/controllers

# App Module
angular.module("mb", ["mb.controllers", "mb.directives", "mb.filters", "bootstrap", "mb.pager"])
  .config [
    "$routeProvider", "$locationProvider", (route, location) ->
      route
        # Main page, list of all available databases
        .when "/",
            templateUrl: "/ng/templates/databases.html",
            controller: "databases"

        # List of collections for the given database
        .when "/databases/:dbName/collections",
            templateUrl: "/ng/templates/collections.html",
            controller: "collections"

        # list of documents for the given collection
        .when "/databases/:dbName/collections/:collectionName",
            templateUrl: "/ng/templates/documents.html",
            controller: "documents"

        # Information about the server
        .when "/server_info",
            templateUrl: "/ng/templates/server_info.html",
            controller: "serverInfo"

        .otherwise(redirectTo: "/")

      location.html5Mode(true)
  ]
