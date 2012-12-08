module = angular.module("mb.controllers")

# TODO find better solution for breadcrumbs
class BreadcrumbsController
  constructor: (@$rootScope, @$scope) ->

    @$scope.showDatabase = => @$scope.dbName
    @$scope.showCollection = => @$scope.collectionName

    @$rootScope.$on "$routeChangeSuccess", (scope, route) =>
      @$scope.dbName = route.params.dbName
      @$scope.collectionName = route.params.collectionName

      if @$scope.dbName
        @$scope.database =
          name: @$scope.dbName

        if @$scope.collectionName
          @$scope.collection =
            dbName: @$scope.dbName
            name: @$scope.collectionName

BreadcrumbsController.$inject = ["$rootScope", "$scope"]

module.controller "breadcrumbs", BreadcrumbsController
