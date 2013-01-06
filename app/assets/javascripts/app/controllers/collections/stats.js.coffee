module = angular.module("mb.controllers")

class CollectionsStatsController
  @$inject = ["$scope", "$routeParams", "Collection"]
  constructor: (@$scope, @$routeParams, Collection) ->
    @$scope.dbName = @$routeParams.dbName
    @$scope.collectionName = @$routeParams.collectionName

    @collection = new Collection(dbName: @$scope.dbName, name: @$scope.collectionName)
    @fetchStats()

  fetchStats: ->
    @collection.$stats (data) =>
      @$scope.stats = data

module.controller "collections.stats", CollectionsStatsController
