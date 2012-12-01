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

  $scope.delete = (document) ->
    confirmationDialog
      message: "Are you sure?"
      onOk: ->
        resource = new Document()
        params = dbName: $scope.dbName, collectionName: $scope.collectionName, id: document.id

        resource.$delete params, ->
          $scope.fetchDocuments()
