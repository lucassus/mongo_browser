# TODO dry it...

@DatabasesCtrl = ($scope, $element, $filter) ->
  $scope.databases = $element.data('databases')

  $scope.$watch 'filterValue', ->
    $scope.filteredDatabases = $filter('filter')($scope.databases, $scope.filterValue)

  $scope.noMatches = ->
    $scope.filteredDatabases.length is 0

@CollectionsCtrl = ($scope, $element, $filter) ->
  $scope.collections = $element.data('collections')

  $scope.$watch 'filterValue', ->
    $scope.filteredCollections = $filter('filter')($scope.collections, $scope.filterValue)

  $scope.noMatches = ->
    $scope.filteredCollections.length is 0
