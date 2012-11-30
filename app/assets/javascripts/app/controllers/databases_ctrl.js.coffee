@DatabasesCtrl = ($scope, $http, tableFilterFactory, confirmationDialog, doAction) ->

  $scope.loading = true
  $http.get("/databases.json").success (data) ->
    $scope.databases = data
    $scope.tableFilter = tableFilterFactory($scope, "databases")

    $scope.$on "FilterChange", (event, value) ->
      $scope.tableFilter.filter(value)

    $scope.loading = false

  $scope.isLoading = -> $scope.loading

  $scope.delete = (database) ->
    confirmationDialog
      message: "Deleting #{database.name}. Are you sure?"
      onOk: ->
        url = "/databases/#{database.name}"
        doAction(url, "delete")
