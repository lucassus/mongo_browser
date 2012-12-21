module = angular.module("mb.controllers")

class MainController
  @$inject = ["$scope", "$http"]
  constructor: (@$scope, @$http) ->
    @$http.get("/api/version.json").success (data) =>
      @$scope.appVersion = data.version
      @$scope.environment = data.environment

    @$scope.showEnvironment = =>
      @$scope.environment != "production"

module.controller "main", MainController
