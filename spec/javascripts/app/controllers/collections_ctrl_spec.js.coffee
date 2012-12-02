describe "collections", ->
  beforeEach module("mb.controllers")
  beforeEach module("mocks")

  $scope = null
  $httpBackend = null
  alerts = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    alerts = $injector.get("alerts")

    $routeParams = $injector.get("$routeParams")
    $routeParams.dbName = "test_database"

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.when("GET", "/api/databases/test_database/collections.json")
        .respond([])
    $httpBackend.when("GET", "/api/databases/test_database/stats.json")
        .respond({})

    $scope = $rootScope.$new()
    $controller "collections",
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
      beforeEach inject (bootboxDialogsHandler) ->
        $httpBackend.when("DELETE", "/api/databases/test_database/collections/dummy-collection-id.json")
            .respond([])

        spyOn(alerts, "info")
        $scope.delete(name: "dummy-collection-id")
        bootboxDialogsHandler.confirmed()

      it "sends a delete request", ->
        $httpBackend.flush()

      it "displays a flash message", ->
        $httpBackend.flush()
        expect(alerts.info).toHaveBeenCalledWith("Collection dummy-collection-id has been deleted.")

    describe "when the dialog was disposed", ->
      it "does nothing", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete(name: "dummy-collection-id")
        bootboxDialogsHandler.disposed()
