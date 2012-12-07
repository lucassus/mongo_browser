module = angular.module("mb.controllers")

class DatabasesController
  constructor: (@$scope, @Database, @confirmationDialog, @alerts) ->
    @loading = false
    @fetchDatabases()

    @bindScope()

  bindScope: ->
    @$scope.filterValue = ""

    @$scope.isLoading = -> @loading
    @$scope.delete = (database) => @dropWithConfirmation(database)

  fetchDatabases: ->
    @loading = true
    @Database.query(@onLoadComplete)

  onLoadComplete: (data) =>
    @$scope.databases = data
    @loading = false

  dropWithConfirmation: (database) =>
    @confirmationDialog
      message: "Deleting #{database.name}. Are you sure?"
      onOk: => @drop(database)

  drop: (database) ->
    resource = new @Database()
    params = id: database.name

    resource.$delete params, =>
      @alerts.info("Database #{database.name} has been deleted.")
      @fetchDatabases()

DatabasesController.$inject = ["$scope",
  "Database", "confirmationDialog", "alerts"]

module.controller "databases", DatabasesController
