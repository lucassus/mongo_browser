module = angular.module("mb.controllers")

module.controller "main", ($scope, $http) ->
  $http.get("/api/version.json").success (data) ->
    $scope.appVersion = data.version
