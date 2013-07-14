class MainCtrl
  @$inject = ["$scope", "$http"]
  constructor: (@$scope, @$http) ->
    @fetchVersion()

    @$scope.showEnvironment = =>
      @$scope.environment != "production"

  fetchVersion: ->
    @$http.get("/api/version").success (data) =>
      @$scope.appVersion = data.version
      @$scope.environment = data.environment

angular.module("mb")
  .controller("main", MainCtrl)
