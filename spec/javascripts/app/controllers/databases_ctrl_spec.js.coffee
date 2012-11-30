describe "DatabasesCtrl", ->
  beforeEach module("mb.services")
  beforeEach module("mocks")

  $scope = null
  $httpBackend = null
  doAction = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $httpBackend = $injector.get('$httpBackend')

    $scope = $rootScope.$new()
    doAction = jasmine.createSpy("do action")

    $httpBackend.when("GET", "/api/databases.json").respond([])
    $controller window.DatabasesCtrl,
        $scope: $scope
        doAction: doAction

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "#delete", ->
    it "shows a confirmation dialog", inject (bootboxDialogsHandler) ->
      spyOn(bootboxDialogsHandler, "confirm")
      $scope.delete(name: "test_database_name")
      expect(bootboxDialogsHandler.confirm).toHaveBeenCalledWith \
          "Deleting test_database_name. Are you sure?",
          jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      it "sends a delete request", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete(name: "test_database_name")
        bootboxDialogsHandler.confirmed()

        # Then
        expect(doAction).toHaveBeenCalledWith \
            "/databases/test_database_name",
            "delete"

    describe "when the dialog was disposed", ->
      it "does nothing", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete(name: "test_database_name")
        bootboxDialogsHandler.disposed()

        # Then
        expect(doAction).not.toHaveBeenCalled()
