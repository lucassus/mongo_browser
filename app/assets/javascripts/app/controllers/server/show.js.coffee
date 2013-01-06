module = angular.module("mb.controllers")

class ServerShowController
  @$inject = ["$scope", "$http"]
  constructor: (@$scope, @$http) ->
    @$scope.loading = true
    @$http.get("/api/server_info.json").success(@onLoadComplete)

  onLoadComplete: (data) =>
    @$scope.serverInfo = data
    @$scope.loading = false

module.controller "server.show", ServerShowController
