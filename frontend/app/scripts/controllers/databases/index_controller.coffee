class DatabasesIndexCtrl
  @$inject = ["$scope", "Database", "confirmationDialog", "alerts"]
  constructor: (@$scope, @Database, @confirmationDialog, @alerts) ->
    @loading = false

    # Scope variables
    @$scope.filterValue = ""

    # Scope methods
    @$scope.isLoading = => @loading
    @$scope.delete = (database) => @dropWithConfirmation(database)

    @fetchDatabases()

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

  drop: (data) ->
    database = new @Database(data)
    database.$delete =>
      @alerts.info("Database #{data.name} has been deleted.")
      @fetchDatabases()

angular.module("mb")
  .controller("databases.index", DatabasesIndexCtrl)
