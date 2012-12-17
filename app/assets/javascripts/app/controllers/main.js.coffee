module = angular.module("mb.controllers")

class MainController
  @$inject = ["$scope", "$http"]
  constructor: (@$scope, @$http) ->
    @$http.get("/api/version.json").success (data) =>
      @$scope.appVersion = data.version

module.controller "main", MainController
