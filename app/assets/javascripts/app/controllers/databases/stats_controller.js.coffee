class DatabasesStatsCtrl
  @$inject = ["$scope", "$routeParams", "Database"]
  constructor: (@$scope, $routeParams, Database) ->
    { @dbName } = $routeParams
    @$scope.dbName = @dbName

    @database = new Database(name: @dbName)
    @fetchStats()

  fetchStats: ->
    @database.$stats (data) =>
      @$scope.stats = data

angular.module("mb")
  .controller("databases.stats", DatabasesStatsCtrl)
