module = angular.module("mb.controllers")

class ServerInfo
  constructor: (@$scope, @$http) ->
    @$scope.loading = true
    @$http.get("/api/server_info.json").success(@onLoadComplete)

  onLoadComplete: (data) =>
    @$scope.serverInfo = data
    @$scope.loading = false

ServerInfo.$inject = ["$scope", "$http"]

module.controller "serverInfo", ServerInfo
