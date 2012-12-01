#= require app/services
#= require app/resources
#= require app/directives
#= require app/filters
#= require_tree ./app/controllers

# App Module
angular.module("mb", ["mb.services", "mb.resources", "mb.directives", "mb.filters"])
  .config [
    "$routeProvider", "$locationProvider", (route, location) ->
      route
        .when "/",
            templateUrl: "/ng/templates/databases.html",
            controller: window.DatabasesCtrl

        .when "/server_info",
            templateUrl: "/ng/templates/server_info.html",
            controller: window.ServerInfoCtrl

        .when "/databases/:dbName/collections",
            templateUrl: "/ng/templates/collections.html",
            controller: window.CollectionsCtrl

        .when "/databases/:dbName/collections/:collectionName",
            templateUrl: "/ng/templates/documents.html",
            controller: window.DocumentsCtrl

        .otherwise(redirectTo: "/")

      location.html5Mode(true)
  ]
