module = angular.module("mb.controllers")

class ServersShowController
  @$inject = ["$scope", "$http"]
  constructor: (@$scope, @$http) ->
    @$scope.loading = true
    @fetchServerInfo()

  fetchServerInfo: ->
    @$http.get("/api/server_info.json").success(@onLoadComplete)

  onLoadComplete: (data) =>
    @$scope.serverInfo = data
    @$scope.loading = false

module.controller "servers.show", ServersShowController
