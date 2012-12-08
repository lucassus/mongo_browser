module = angular.module("mb.controllers")

class MainController
  constructor: (@$scope, @$http) ->
    @$http.get("/api/version.json").success (data) =>
      @$scope.appVersion = data.version

MainController.$inject = ["$scope", "$http"]

module.controller "main", MainController
