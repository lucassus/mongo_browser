describe "collections", ->
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

  describe "#isLoading", ->
    it "returns true when the resouce it loading", ->
      $scope.loading = true
      expect($scope.isLoading()).toBeTruthy()

    it "otherwise returns false", ->
      $scope.loading = false
      expect($scope.isLoading()).toBeFalsy()

  # TODO refactor this spec
  describe "#delete", ->
    collection = null

    beforeEach ->
      collection = dbName: "test_database", name: "dummy-collection-id"

    it "shows a confirmation dialog", inject (dialogsHandler) ->
      spyOn(dialogsHandler, "confirm")

      $scope.delete(collection)

      expect(dialogsHandler.confirm).toHaveBeenCalledWith "Deleting dummy-collection-id. Are you sure?",
        jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      beforeEach inject (dialogsHandler) ->
        $httpBackend.when("DELETE", "/api/databases/test_database/collections/dummy-collection-id.json")
          .respond([])

        spyOn(alerts, "info")
        $scope.delete(collection)
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
