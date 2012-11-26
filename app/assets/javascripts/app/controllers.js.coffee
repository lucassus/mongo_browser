@DatabasesCtrl = ($scope, $element, tableFilterFactory, confirmationDialog, doAction) ->
  $scope.databases = $element.data("databases")
  $scope.tableFilter = tableFilterFactory($scope, "databases")

  $scope.$on "FilterChange", (event, value) ->
    $scope.tableFilter.filter(value)

  $scope.delete = (database) ->
    confirmationDialog
      message: "Deleting #{database.name}. Are you sure?"
      onOk: ->
        url = "/databases/#{database.name}"
        doAction(url, "delete")

@CollectionsCtrl = ($scope, $element, tableFilterFactory, confirmationDialog, doAction) ->
  dbName = $element.data("db-name")
  $scope.collections = $element.data("collections")
  $scope.tableFilter = tableFilterFactory($scope, "collections")

  $scope.$on "FilterChange", (event, value) ->
    $scope.tableFilter.filter(value)

  $scope.delete = (collection) ->
    confirmationDialog
      message: "Deleting #{collection.name}. Are you sure?"
      onOk: ->
        url = "/databases/#{dbName}/collections/#{collection.name}"
        doAction(url, "delete")

@DocumentsCtrl = ($scope, $element, confirmationDialog, doAction) ->
  dbName = $element.data("db-name")
  collectionName = $element.data("collection-name")

  $scope.delete = (id) ->
    confirmationDialog
      message: "Are you sure?"
      onOk: ->
        url = "/databases/#{dbName}/collections/#{collectionName}/#{id}"
        doAction(url, "delete")
