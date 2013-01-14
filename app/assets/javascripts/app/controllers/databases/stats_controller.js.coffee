module = angular.module("mb.controllers")

class DatabasesStatsController
  @$inject = ["$scope", "$routeParams", "Database"]
  constructor: (@$scope, $routeParams, Database) ->
    { @dbName } = $routeParams
    @$scope.dbName = @dbName

    @database = new Database(name: @dbName)
    @fetchStats()

  fetchStats: ->
    @database.$stats (data) =>
      @$scope.stats = data

module.controller "databases.stats", DatabasesStatsController
