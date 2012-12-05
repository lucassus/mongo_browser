module = angular.module("mb.controllers")

module.controller "databases",  ($scope, Database, confirmationDialog, alerts) ->
  $scope.filterValue = ""

  _onLoadComplete = (data) ->
    $scope.databases = data
    $scope.loading = false

  $scope.fetchDatabases = ->
    $scope.loading = true
    $scope.databases = Database.query(_onLoadComplete)

  $scope.fetchDatabases()

  $scope.isLoading = -> $scope.loading

  $scope.delete = (database) ->
    confirmationDialog
      message: "Deleting #{database.name}. Are you sure?"
      onOk: ->
        resource = new Database()
        params = id: database.name

        resource.$delete params, ->
          alerts.info("Database #{database.name} has been deleted.")
          $scope.fetchDatabases()
