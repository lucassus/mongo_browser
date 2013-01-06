module = angular.module("mb.controllers")

# TODO clenup this controller, see DatabasesController
class CollectionsStatsController
  @$inject = ["$scope", "$routeParams", "Collection"]
  constructor: (@$scope, @$routeParams, @Collection) ->
    @$scope.dbName = @$routeParams.dbName
    @$scope.collectionName = @$routeParams.collectionName

    collection = new @Collection(dbName: @$scope.dbName, name: @$scope.collectionName)
    collection.$stats (data) =>
      @$scope.collectionStats = data

module.controller "collections.stats", CollectionsStatsController
