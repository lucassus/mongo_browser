describe "servers show controller", ->
  beforeEach module("mb.controllers")

  $scope = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $scope = $rootScope.$new()

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.whenGET("/api/server_info.json").respond([])

    $controller "servers.show",
      $scope: $scope

    $httpBackend.flush()

  it "fetches information about the server", ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
