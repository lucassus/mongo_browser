@CollectionsCtrl = ($scope, $routeParams, $http, tableFilterFactory, confirmationDialog, doAction) ->
  $scope.dbName = $routeParams.dbName

  _onLoadComplete = (data) ->
    $scope.collections = data
    $scope.tableFilter = tableFilterFactory($scope, "collections")

    $scope.$on "FilterChange", (event, value) ->
      $scope.tableFilter.filter(value)

    $scope.loading = false

  $scope.loading = true
  $http.get("/api/databases/#{$scope.dbName}.json").success(_onLoadComplete)

  $scope.isLoading = -> $scope.loading

  $scope.delete = (collection) ->
    confirmationDialog
      message: "Deleting #{collection.name}. Are you sure?"
      onOk: ->
        url = "/databases/#{$scope.dbName}/collections/#{collection.name}"
        doAction(url, "delete")
