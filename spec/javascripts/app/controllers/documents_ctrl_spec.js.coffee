describe "DocumentsCtrl", ->
  beforeEach module("mb.services")
  beforeEach module("mb.resources")
  beforeEach module("mocks")

  $scope = null
  $httpBackend = null
  alerts = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    alerts = $injector.get("alerts")

    $routeParams = $injector.get("$routeParams")
    $routeParams.dbName = "test_database"
    $routeParams.collectionName = "test_collection"

    $httpBackend = $injector.get('$httpBackend')
    $httpBackend.when("GET", "/api/databases/test_database/collections/test_collection/documents.json")
        .respond([])
    $httpBackend.when("GET", "/api/databases/test_database/collections/test_collection/stats.json")
        .respond({})

    $scope = $rootScope.$new()
    $controller window.DocumentsCtrl,
      $scope: $scope

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  # TODO rewrite this spec
  describe "#delete", ->
    it "shows a confirmation dialog", inject (bootboxDialogsHandler) ->
      spyOn(bootboxDialogsHandler, "confirm")
      $scope.delete(id: "dummy-document-id")
      expect(bootboxDialogsHandler.confirm).toHaveBeenCalledWith \
          "Are you sure?",
          jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      beforeEach inject (bootboxDialogsHandler) ->
        $httpBackend.when("DELETE", "/api/databases/test_database/collections/test_collection/documents/dummy-document-id.json")
            .respond([])

        spyOn(alerts, "info")
        $scope.delete(id: "dummy-document-id")
        bootboxDialogsHandler.confirmed()

      it "sends a delete request", ->
        $httpBackend.flush()

      it "displays a flash message", ->
        $httpBackend.flush()
        expect(alerts.info).toHaveBeenCalledWith("Document dummy-document-id has been deleted.")

    describe "when the dialog was disposed", ->
      it "does nothing", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete(id: "dummy-document-id")
        bootboxDialogsHandler.disposed()
