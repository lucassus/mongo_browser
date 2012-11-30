@DatabasesCtrl = ($scope, Database, tableFilterFactory, confirmationDialog, doAction) ->
  _onLoadComplete = (data) ->
    $scope.tableFilter = tableFilterFactory($scope, "databases")

    $scope.$on "FilterChange", (event, value) ->
      $scope.tableFilter.filter(value)

    $scope.loading = false

  $scope.loading = true
  $scope.databases = Database.query(_onLoadComplete)

  $scope.isLoading = -> $scope.loading

  $scope.delete = (database) ->
    confirmationDialog
      message: "Deleting #{database.name}. Are you sure?"
      onOk: ->
        url = "/databases/#{database.name}"
        doAction(url, "delete")
