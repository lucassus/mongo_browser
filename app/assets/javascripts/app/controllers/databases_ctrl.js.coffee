@DatabasesCtrl = ($scope, Database, tableFilterFactory, confirmationDialog) ->
  _onLoadComplete = (data) ->
    $scope.tableFilter = tableFilterFactory($scope, "databases")

    $scope.$on "FilterChange", (event, value) ->
      $scope.tableFilter.filter(value)

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
        params = dbName: database.name

        resource.$delete params, ->
          $scope.fetchDatabases()
