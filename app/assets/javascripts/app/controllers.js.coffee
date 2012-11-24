# TODO dry it...

@DatabasesCtrl = ($scope, $element, $filter) ->
  $scope.databases = $element.data("databases")

  $scope.filteredDatabases = $scope.databases
  $scope.$on "FilterChange", (event, value) ->
    $scope.filteredDatabases = $filter("filter")($scope.databases, value)

  $scope.noMatches = ->
    $scope.filteredDatabases.length is 0

@CollectionsCtrl = ($scope, $element, $filter) ->
  $scope.collections = $element.data("collections")

  $scope.filteredCollections = $scope.collections
  $scope.$on "FilterChange", (event, value) ->
    $scope.filteredCollections = $filter("filter")($scope.collections, value)

  $scope.noMatches = ->
    $scope.filteredCollections.length is 0
