describe "DatabasesCtrl", ->
  beforeEach module("mb.services")
  beforeEach module("mb.resources")
  beforeEach module("mocks")

  $scope = null
  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $httpBackend = $injector.get('$httpBackend')

    $scope = $rootScope.$new()

    $httpBackend.when("GET", "/api/databases.json").respond([])
    $controller window.DatabasesCtrl,
        $scope: $scope

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  # TODO rewrite this spec
  describe "#delete", ->
    it "shows a confirmation dialog", inject (bootboxDialogsHandler) ->
      spyOn(bootboxDialogsHandler, "confirm")
      $scope.delete(name: "test_database_name")
      expect(bootboxDialogsHandler.confirm).toHaveBeenCalledWith \
          "Deleting test_database_name. Are you sure?",
          jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      it "sends a delete request", inject (bootboxDialogsHandler) ->
        # Given
        $httpBackend.when("DELETE", "/api/databases/test_database_name.json")
            .respond([])

        # When
        $scope.delete(name: "test_database_name")
        bootboxDialogsHandler.confirmed()
        $httpBackend.flush()

    describe "when the dialog was disposed", ->
      it "does nothing", inject (bootboxDialogsHandler) ->
        # When
        $scope.delete(name: "test_database_name")
        bootboxDialogsHandler.disposed()
