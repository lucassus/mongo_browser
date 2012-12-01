describe "CollectionsCtrl", ->
  beforeEach module("mb.services")
  beforeEach module("mb.resources")
  beforeEach module("mocks")

  $scope = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $scope = $rootScope.$new()
    $httpBackend = $injector.get("$httpBackend")

    $routeParams = $injector.get("$routeParams")
    $routeParams.dbName = "test_database"

    $httpBackend.when("GET", "/api/databases/test_database/collections.json")
        .respond([])

    $controller window.CollectionsCtrl,
      $scope: $scope

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  # TODO rewrite this spec
  describe "#delete", ->
    it "shows a confirmation dialog", inject (bootboxDialogsHandler) ->
      spyOn(bootboxDialogsHandler, "confirm")
      $scope.delete(name: "dummy-collection-id")
      expect(bootboxDialogsHandler.confirm).toHaveBeenCalledWith \
          "Deleting dummy-collection-id. Are you sure?",
          jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      it "sends a delete request", inject (bootboxDialogsHandler) ->
        # Given
        $httpBackend.when("DELETE", "/api/databases/test_database/collections/dummy-collection-id.json")
            .respond([])

        # When
        $scope.delete(name: "dummy-collection-id")
        bootboxDialogsHandler.confirmed()
        $httpBackend.flush()

    describe "when the dialog was disposed", ->
      it "does nothing", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete(name: "dummy-collection-id")
        bootboxDialogsHandler.disposed()
