describe "servers show controller", ->
  beforeEach module("mb")

  $scope = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $scope = $rootScope.$new()

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.whenGET("/api/server_info").respond([])

    $controller "servers.show",
      $scope: $scope

    $httpBackend.flush()

  it "fetches information about the server", ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
