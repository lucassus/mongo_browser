module = angular.module("mb.controllers")

module.controller "breadcrumbs", ($rootScope, $scope) ->

  $rootScope.$on "$routeChangeSuccess", (scope, newRoute) ->
    $scope.dbName = newRoute.params.dbName
    $scope.collectionName = newRoute.params.collectionName
