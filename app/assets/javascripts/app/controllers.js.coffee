@DatabasesCtrl = ($scope, $element, $filter) ->
  $scope.databases = $element.data('databases')

  $scope.$watch 'filterValue', ->
    $scope.filteredDatabases = $filter('filter')($scope.databases, $scope.filterValue)

@CollectionsCtrl = ($scope, $element, $filter) ->
  $scope.collections = $element.data('collections')

  $scope.$watch 'filterValue', ->
    $scope.filteredCollections = $filter('filter')($scope.collections, $scope.filterValue)
