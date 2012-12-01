@CollectionsCtrl = ($scope, $routeParams, Collection, tableFilterFactory, confirmationDialog) ->
  $scope.dbName = $routeParams.dbName

  _onLoadComplete = (data) ->
    $scope.tableFilter = tableFilterFactory($scope, "collections")

    $scope.$on "FilterChange", (event, value) ->
      $scope.tableFilter.filter(value)

    $scope.loading = false

  $scope.fetchCollections = ->
    $scope.loading = true
    $scope.collections = Collection.query({ dbName: $scope.dbName }, _onLoadComplete)

  $scope.fetchCollections()

  $scope.isLoading = -> $scope.loading

  $scope.delete = (collection) ->
    confirmationDialog
      message: "Deleting #{collection.name}. Are you sure?"
      onOk: ->
        resource = new Collection()
        params = dbName: $scope.dbName, collectionName: collection.name

        resource.$delete params, ->
          $scope.fetchCollections()
