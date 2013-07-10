# TODO find better solution for breadcrumbs
class BreadcrumbsCtrl
  @$inject = ["$rootScope", "$scope"]
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

angular.module("mb")
  .controller("breadcrumbs", BreadcrumbsCtrl)
