@CollectionsCtrl = ($scope, $routeParams, Collection, tableFilterFactory, confirmationDialog, doAction) ->
  $scope.dbName = $routeParams.dbName

  _onLoadComplete = (data) ->
    $scope.tableFilter = tableFilterFactory($scope, "collections")

    $scope.$on "FilterChange", (event, value) ->
      $scope.tableFilter.filter(value)

    $scope.loading = false

  $scope.loading = true
  $scope.collections = Collection.query({ dbName: $scope.dbName }, _onLoadComplete)

  $scope.isLoading = -> $scope.loading

  $scope.delete = (collection) ->
    confirmationDialog
      message: "Deleting #{collection.name}. Are you sure?"
      onOk: ->
        url = "/databases/#{$scope.dbName}/collections/#{collection.name}"
        doAction(url, "delete")
