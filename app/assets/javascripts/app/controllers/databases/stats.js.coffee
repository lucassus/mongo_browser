module = angular.module("mb.controllers")

class DatabasesStatsController
  @$inject = ["$scope", "$routeParams", "Database"]
  constructor: (@$scope, @$routeParams, Database) ->
    @$scope.dbName = @$routeParams.dbName

    @database = new Database(name: @$scope.dbName)
    @fetchStats()

  fetchStats: ->
    @database.$stats (data) =>
      @$scope.stats = data

module.controller "databases.stats", DatabasesStatsController
