module = angular.module("mb.controllers")

# TODO clenup this controller, see DatabasesController
class DatabasesStatsController
  @$inject = ["$scope", "$routeParams", "Database"]
  constructor: (@$scope, @$routeParams, @Database) ->
    @$scope.dbName = @$routeParams.dbName

    new @Database(name: @$scope.dbName).$stats (data) =>
      @$scope.dbStats = data

module.controller "databases.stats", DatabasesStatsController
