module = angular.module("mb.controllers")

class CollectionsStatsController
  @$inject = ["$scope", "$routeParams", "Collection"]
  constructor: (@$scope, $routeParams, Collection) ->
    { @dbName, @collectionName } = $routeParams

    @$scope.dbName = @dbName
    @$scope.collectionName = @collectionName

    @collection = new Collection(dbName: @dbName, name: @collectionName)
    @fetchStats()

  fetchStats: ->
    @collection.$stats (data) =>
      @$scope.stats = data

module.controller "collections.stats", CollectionsStatsController
