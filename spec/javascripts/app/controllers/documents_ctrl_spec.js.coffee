describe "DocumentsCtrl", ->
  beforeEach module("mb.services")
  beforeEach module("mb.resources")
  beforeEach module("mocks")

  $scope = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $scope = $rootScope.$new()
    confirmationDialog = $injector.get("confirmationDialog")

    $routeParams = $injector.get("$routeParams")
    $routeParams.dbName = "test_database"
    $routeParams.collectionName = "test_collection"

    $httpBackend = $injector.get('$httpBackend')
    $httpBackend.when("GET", "/api/databases/test_database/collections/test_collection/documents.json")
        .respond([])
    $httpBackend.when("GET", "/api/databases/test_database/collections/test_collection/stats.json")
        .respond({})

    $controller window.DocumentsCtrl,
      $scope: $scope
      confirmationDialog: confirmationDialog

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
      it "sends a delete request", inject (bootboxDialogsHandler) ->
        # Given
        $httpBackend.when("DELETE", "/api/databases/test_database/collections/test_collection/documents/dummy-document-id.json")
          .respond([])

        # When
        $scope.delete(id: "dummy-document-id")
        bootboxDialogsHandler.confirmed()
        $httpBackend.flush()

    describe "when the dialog was disposed", ->
      it "does nothing", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete(id: "dummy-document-id")
        bootboxDialogsHandler.disposed()
