module = angular.module("mb.controllers")

module.controller "serverInfo", ($scope, $http) ->
  _onLoadComplete = (data) ->
    $scope.serverInfo = data
    $scope.loading = false

  $scope.loading = true
  $http.get("/api/server_info.json").success(_onLoadComplete)
