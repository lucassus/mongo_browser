describe "databases", ->
  beforeEach module("mb.controllers")
  beforeEach module("mb.dialogs")
  beforeEach module("mocks")

  $scope = null
  $httpBackend = null
  alerts = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    alerts = $injector.get("alerts")

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.when("GET", "/api/databases.json").respond([])

    $scope = $rootScope.$new()
    $controller "databases",
        $scope: $scope

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  # TODO rewrite this spec
  describe "#delete", ->
    it "shows a confirmation dialog", inject (dialogsHandler) ->
      spyOn(dialogsHandler, "confirm")
      $scope.delete(name: "test_database_name")
      expect(dialogsHandler.confirm).toHaveBeenCalledWith \
          "Deleting test_database_name. Are you sure?",
          jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      beforeEach inject (dialogsHandler) ->
        $httpBackend.when("DELETE", "/api/databases.json?id=test_database_name")
            .respond([])

        spyOn(alerts, "info")
        $scope.delete(name: "test_database_name")
        dialogsHandler.confirmed()

      it "sends a delete request", ->
        $httpBackend.flush()

      it "displays a flash message", ->
        $httpBackend.flush()
        expect(alerts.info).toHaveBeenCalledWith("Database test_database_name has been deleted.")

    describe "when the dialog was disposed", ->
      it "does nothing", inject (dialogsHandler) ->
        # When
        $scope.delete(name: "test_database_name")
        dialogsHandler.disposed()
