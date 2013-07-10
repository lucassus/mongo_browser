describe "breadcrumbs", ->
  beforeEach module("mb")

  $scope = null

  beforeEach inject ($rootScope, $controller) ->
    $scope = $rootScope.$new()

    $controller "breadcrumbs",
      $scope: $scope,

  describe "#showDatabase", ->
    it "return true when the database is available", ->
      $scope.dbName = "foo"
      expect($scope.showDatabase()).toBeTruthy()

    it "return false when the database is not available", ->
      $scope.dbName = null
      expect($scope.showDatabase()).toBeFalsy()

  describe "#showCollection", ->
    it "return true when the database is available", ->
      $scope.collectionName = "foo"
      expect($scope.showCollection()).toBeTruthy()

    it "return false when the database is not available", ->
      $scope.collectionName = null
      expect($scope.showCollection()).toBeFalsy()
