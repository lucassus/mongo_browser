describe "serverInfo", ->
  beforeEach module("mb.controllers")
  beforeEach module("mocks")

  $scope = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $scope = $rootScope.$new()

    $httpBackend = $injector.get('$httpBackend')
    $httpBackend.when("GET", "/api/server_info.json").respond([])

    $controller "serverInfo",
      $scope: $scope

    $httpBackend.flush()

  it "fetches information about the server", ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
