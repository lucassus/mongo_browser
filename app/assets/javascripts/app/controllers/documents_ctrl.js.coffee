@DocumentsCtrl = ($scope, $routeParams, $http, confirmationDialog, doAction) ->
  $scope.dbName = $routeParams.dbName
  $scope.collectionName = $routeParams.collectionName

  _onLoadComplete = (data) ->
    $scope.documents = data
    $scope.loading = false

  $scope.loading = true
  $http.get("/api/databases/#{$scope.dbName}/collections/#{$scope.collectionName}.json")
      .success(_onLoadComplete)

  $scope.delete = (id) ->
    confirmationDialog
      message: "Are you sure?"
      onOk: ->
        url = "/databases/#{$scope.dbName}/collections/#{$scope.collectionName}/#{id}"
        doAction(url, "delete")
