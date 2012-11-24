@DatabasesCtrl = ($scope, $element, tableFilterFactory) ->
  $scope.databases = $element.data("databases")
  $scope.tableFilter = tableFilterFactory($scope, "databases")

  $scope.$on "FilterChange", (event, value) ->
    $scope.tableFilter.filter(value)

@CollectionsCtrl = ($scope, $element, tableFilterFactory) ->
  $scope.collections = $element.data("collections")
  $scope.tableFilter = tableFilterFactory($scope, "collections")

  $scope.$on "FilterChange", (event, value) ->
    $scope.tableFilter.filter(value)
