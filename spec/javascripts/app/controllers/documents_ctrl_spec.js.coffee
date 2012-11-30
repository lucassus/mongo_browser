describe "DocumentsCtrl", ->
  beforeEach module("mb.services")
  beforeEach module("mb.resources")
  beforeEach module("mocks")

  $scope = null
  doAction = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $scope = $rootScope.$new()
    confirmationDialog = $injector.get("confirmationDialog")

    $routeParams = $injector.get("$routeParams")
    $routeParams.dbName = "test_database"
    $routeParams.collectionName = "test_collection"

    doAction = jasmine.createSpy("do action")

    $httpBackend = $injector.get('$httpBackend')
    $httpBackend.when("GET", "/api/databases/test_database/collections/test_collection.json")
        .respond([])

    $controller window.DocumentsCtrl,
      $scope: $scope
      confirmationDialog: confirmationDialog
      doAction: doAction

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "#delete", ->
    it "shows a confirmation dialog", inject (bootboxDialogsHandler) ->
      spyOn(bootboxDialogsHandler, "confirm")
      $scope.delete("dummy-document-id")
      expect(bootboxDialogsHandler.confirm).toHaveBeenCalledWith \
          "Are you sure?",
          jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      it "sends a delete request", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete("dummy-document-id")
        bootboxDialogsHandler.confirmed()

        # Then
        expect(doAction).toHaveBeenCalledWith \
            "/databases/test_database/collections/test_collection/dummy-document-id",
            "delete"

    describe "when the dialog was disposed", ->
      it "does nothing", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete("dummy-document-id")
        bootboxDialogsHandler.disposed()

        # Then
        expect(doAction).not.toHaveBeenCalled()
