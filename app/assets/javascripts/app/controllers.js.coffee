@DatabasesCtrl = ($scope, $element, $log, tableFilterFactory, confirmationDialog, doDelete) ->
  $scope.databases = $element.data("databases")
  $scope.tableFilter = tableFilterFactory($scope, "databases")

  $scope.$on "FilterChange", (event, value) ->
    $scope.tableFilter.filter(value)

  $scope.delete = (database) ->
    confirmationDialog
      message: "Deleting #{database.name}. Are you sure?"
      onOk: -> doDelete("/databases/#{database.name}")

@CollectionsCtrl = ($scope, $element, tableFilterFactory, confirmationDialog, doDelete) ->
  $scope.dbName = $element.data("db-name")
  $scope.collections = $element.data("collections")
  $scope.tableFilter = tableFilterFactory($scope, "collections")

  $scope.$on "FilterChange", (event, value) ->
    $scope.tableFilter.filter(value)

  $scope.delete = (collection) ->
    confirmationDialog
      message: "Deleting #{collection.name}. Are you sure?"
      onOk: -> doDelete("/databases/#{$scope.dbName}/collections/#{collection.name}")

@DocumentsCtrl = ($scope, $element, confirmationDialog, doDelete) ->
  $scope.dbName = $element.data("db-name")
  $scope.collectionName = $element.data("collection-name")

  $scope.delete = (id) ->
    confirmationDialog
      message: "Are you sure?"
      onOk: -> doDelete("/databases/#{$scope.dbName}/collections/#{$scope.collectionName}/#{id}")
