@DocumentsCtrl = ($scope, $element, confirmationDialog, doAction) ->
  dbName = $element.data("db-name")
  collectionName = $element.data("collection-name")

  $scope.delete = (id) ->
    confirmationDialog
      message: "Are you sure?"
      onOk: ->
        url = "/databases/#{dbName}/collections/#{collectionName}/#{id}"
        doAction(url, "delete")
