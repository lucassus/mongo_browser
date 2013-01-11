describe "collections stats controller", ->
  beforeEach module("mb.controllers")

  $scope = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $routeParams = $injector.get("$routeParams")
    $routeParams.dbName = "test_database"
    $routeParams.collectionName = "test_collection"

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.whenGET("/api/databases/test_database/collections/test_collection/stats.json")
      .respond(foo: "bar")

    $scope = $rootScope.$new()
    $controller "collections.stats",
      $scope: $scope

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it "assings database name", ->
    expect($scope.dbName).toEqual("test_database")

  it "assings collection name", ->
    expect($scope.collectionName).toEqual("test_collection")

  it "fetches the collection stats", ->
    expect($scope.stats).toBeDefined()
    expect(angular.equals({ foo: "bar" }, $scope.stats)).toBeTruthy()
