describe "databases stats controller", ->
  beforeEach module("mb.controllers")

  $scope = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $routeParams = $injector.get("$routeParams")
    $routeParams.dbName = "test_database"

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.whenGET("/api/databases/test_database/stats.json")
      .respond(foo: "bar")

    $scope = $rootScope.$new()
    $controller "databases.stats",
      $scope: $scope

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it "assigns database name", ->
    expect($scope.dbName).toEqual("test_database")

  it "fetches the collection stats", ->
    expect($scope.dbStats).toBeDefined()
    expect(angular.equals({ foo: "bar" }, $scope.dbStats)).toBeTruthy()
