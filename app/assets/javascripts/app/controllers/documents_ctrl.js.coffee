@DocumentsCtrl = ($scope, $routeParams, Document, confirmationDialog, doAction) ->
  $scope.dbName = $routeParams.dbName
  $scope.collectionName = $routeParams.collectionName

  _onLoadComplete = (data) ->
    $scope.loading = false

  $scope.loading = true
  $scope.documents = Document.query({ dbName: $scope.dbName, collectionName: $scope.collectionName }, _onLoadComplete())

  $scope.delete = (id) ->
    confirmationDialog
      message: "Are you sure?"
      onOk: ->
        url = "/databases/#{$scope.dbName}/collections/#{$scope.collectionName}/#{id}"
        doAction(url, "delete")
