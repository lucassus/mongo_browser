class CollectionsStatsCtrl
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

angular.module("mb")
  .controller("collections.stats", CollectionsStatsCtrl)
