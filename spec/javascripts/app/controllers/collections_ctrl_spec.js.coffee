describe "CollectionsCtrl", ->
  beforeEach module("mb.services")
  beforeEach module("mocks")

  $scope = null
  $httpBackend = null
  doAction = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $scope = $rootScope.$new()
    $httpBackend = $injector.get('$httpBackend')
    doAction = jasmine.createSpy("do action")

    $element = $("<div/>")
        .data("db-name", "test_database")
        .data("collections", [])

    $httpBackend.when("GET", "/databases/test_database.json").respond([])
    $controller window.CollectionsCtrl,
      $scope: $scope
      $element: $element
      doAction: doAction

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()


  describe "#delete", ->
    it "shows a confirmation dialog", inject (bootboxDialogsHandler) ->
      spyOn(bootboxDialogsHandler, "confirm")
      $scope.delete(name: "dummy-collection-id")
      expect(bootboxDialogsHandler.confirm).toHaveBeenCalledWith \
          "Deleting dummy-collection-id. Are you sure?",
          jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      it "sends a delete request", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete(name: "dummy-collection-id")
        bootboxDialogsHandler.confirmed()

        # Then
        expect(doAction).toHaveBeenCalledWith \
            "/databases/test_database/collections/dummy-collection-id",
            "delete"

    describe "when the dialog was disposed", ->
      it "does nothing", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete(name: "dummy-collection-id")
        bootboxDialogsHandler.disposed()

        # Then
        expect(doAction).not.toHaveBeenCalled()
