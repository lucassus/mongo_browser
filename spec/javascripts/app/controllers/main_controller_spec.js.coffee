describe "main", ->
  beforeEach module("mb.controllers")

  $scope = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $scope = $rootScope.$new()

    $httpBackend = $injector.get('$httpBackend')
    $httpBackend.whenGET("/api/version").respond([])

    $controller "main",
      $scope: $scope

    $httpBackend.flush()

  it "fetches the app version", ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
