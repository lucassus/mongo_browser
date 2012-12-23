describe "documents", ->
  beforeEach module("mb.controllers")
  beforeEach module("mb.dialogs")
  beforeEach module("mb.alerts")
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
    $httpBackend.when("GET", "/api/databases/test_database/collections/test_collection/documents.json?page=1")
      .respond([])
    $httpBackend.when("GET", "/api/databases/test_database/collections/test_collection/stats.json")
      .respond({})

    $scope = $rootScope.$new()
    $controller "documents",
      $scope: $scope

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "#showDocuments", ->
    it "returns true when the collection size is > 0", ->
      $scope.size = 1
      expect($scope.showDocuments()).toBeTruthy()

    it "return false when the collection size is 0", ->
      $scope.size = 0
      expect($scope.showDocuments()).toBeFalsy()

  # TODO rewrite this spec
  describe "#delete", ->
    it "shows a confirmation dialog", inject (dialogsHandler) ->
      spyOn(dialogsHandler, "confirm")
      $scope.delete(id: "dummy-document-id")
      expect(dialogsHandler.confirm).toHaveBeenCalledWith "Are you sure?",
        jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      beforeEach inject (dialogsHandler) ->
        $httpBackend.when("DELETE", "/api/databases/test_database/collections/test_collection/documents.json?id=dummy-document-id")
          .respond([])

        spyOn(alerts, "info")
        $scope.delete(id: "dummy-document-id")
        dialogsHandler.confirmed()

      it "sends a delete request", ->
        $httpBackend.flush()

      it "displays a flash message", ->
        $httpBackend.flush()
        expect(alerts.info).toHaveBeenCalledWith("Document dummy-document-id has been deleted.")

    describe "when the dialog was disposed", ->
      it "does nothing", inject (dialogsHandler) ->
        # When
        $scope.delete(id: "dummy-document-id")
        dialogsHandler.disposed()
