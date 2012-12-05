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
    it "shows a confirmation dialog", inject (dialogsHandler) ->
      spyOn(dialogsHandler, "confirm")
      $scope.delete(name: "dummy-collection-id")
      expect(dialogsHandler.confirm).toHaveBeenCalledWith \
          "Deleting dummy-collection-id. Are you sure?",
          jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      beforeEach inject (dialogsHandler) ->
        $httpBackend.when("DELETE", "/api/databases/test_database/collections.json?id=dummy-collection-id")
            .respond([])

        spyOn(alerts, "info")
        $scope.delete(name: "dummy-collection-id")
        dialogsHandler.confirmed()

      it "sends a delete request", ->
        $httpBackend.flush()

      it "displays a flash message", ->
        $httpBackend.flush()
        expect(alerts.info).toHaveBeenCalledWith("Collection dummy-collection-id has been deleted.")

    describe "when the dialog was disposed", ->
      it "does nothing", inject (dialogsHandler) ->
        # When
        $scope.delete(name: "dummy-collection-id")
        dialogsHandler.disposed()
