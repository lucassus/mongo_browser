module = angular.module("mb.controllers")

class DatabasesController
  constructor: ($scope, Database, confirmationDialog, alerts) ->
    @scope = $scope
    @Database = Database

    @initialize()

    @scope.isLoading = -> @loading

    @scope.delete = (database) =>
      confirmationDialog
        message: "Deleting #{database.name}. Are you sure?"
        onOk: =>
          resource = new @Database()
          params = id: database.name

          resource.$delete params, =>
            alerts.info("Database #{database.name} has been deleted.")
            @fetchDatabases()

  # Set initial value for the scope
  initialize: ->
    @scope.filterValue = ""

    @loading = false
    @fetchDatabases()

  fetchDatabases: ->
    @loading = true
    @Database.query(@onLoadComplete)

  onLoadComplete: (data) =>
    @scope.databases = data
    @loading = false

module.controller "databases", DatabasesController
