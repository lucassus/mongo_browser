@DocumentsCtrl = ($scope, $routeParams, Document, confirmationDialog) ->
  $scope.dbName = $routeParams.dbName
  $scope.collectionName = $routeParams.collectionName

  _onLoadComplete = (data) ->
    $scope.loading = false

  $scope.fetchDocuments = ->
    $scope.loading = true

    params = dbName: $scope.dbName, collectionName: $scope.collectionName
    $scope.documents = Document.query(params, _onLoadComplete())

  $scope.fetchDocuments()

  $scope.delete = (id) ->
    confirmationDialog
      message: "Are you sure?"
      onOk: ->
        document = new Document()
        params = dbName: $scope.dbName, collectionName: $scope.collectionName, id: id
        document.$delete params, -> $scope.fetchDocuments()
