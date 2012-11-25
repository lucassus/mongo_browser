@DatabasesCtrl = ($scope, $element, $log, tableFilterFactory, confirmationDialog) ->
  $scope.databases = $element.data("databases")
  $scope.tableFilter = tableFilterFactory($scope, "databases")

  $scope.$on "FilterChange", (event, value) ->
    $scope.tableFilter.filter(value)

  $scope.delete = (database) ->
    confirmationDialog
      message: "Deleting #{database.name}. Are you sure?"
      onOk: ->
      onCancel: ->

@CollectionsCtrl = ($scope, $element, tableFilterFactory) ->
  $scope.collections = $element.data("collections")
  $scope.tableFilter = tableFilterFactory($scope, "collections")

  $scope.$on "FilterChange", (event, value) ->
    $scope.tableFilter.filter(value)
