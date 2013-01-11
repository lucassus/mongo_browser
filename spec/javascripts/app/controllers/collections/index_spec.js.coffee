describe "collections index controller", ->
  beforeEach module("mb.controllers")
  beforeEach module("mb.dialogs")
  beforeEach module("mb.alerts")
  beforeEach module("mocks")

  controller = null
  $scope = null

  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $routeParams = $injector.get("$routeParams")
    $routeParams.dbName = "test_database"

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.whenGET("/api/databases/test_database/collections.json")
      .respond([])

    $scope = $rootScope.$new()
    controller = $controller "collections.index",
      $scope: $scope

    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "$scope", ->

    describe "$scope.isLoading", ->
      it "returns true when the resouce it loading", ->
        $scope.loading = true
        expect($scope.isLoading()).toBeTruthy()

      it "otherwise returns false", ->
        $scope.loading = false
        expect($scope.isLoading()).toBeFalsy()

    describe "$scope.delete", ->
      collection = null
      dialogsHandler = null

      beforeEach inject ($injector) ->
        dialogsHandler = $injector.get("dialogsHandler")
        collection = name: "dummy-collection-id"

      it "shows the confirmation dialog", ->
        spyOn(dialogsHandler, "confirm")
        $scope.delete(collection)

        expect(dialogsHandler.confirm).toHaveBeenCalledWith "Deleting dummy-collection-id. Are you sure?",
          jasmine.any(Function)

      describe "when the dialog was confirmed", ->
        it "calls delete method", ->
          spyOn(controller, "deleteWithConfirmation").andCallThrough()
          spyOn(controller, "delete")

          $scope.delete(collection)
          dialogsHandler.confirmed()

          expect(controller.deleteWithConfirmation).toHaveBeenCalledWith(collection)
          expect(controller.delete).toHaveBeenCalledWith(collection)

      describe "when the dialog was disposed", ->
        it "does nothing", ->
          spyOn(controller, "delete")

          $scope.delete(collection)
          dialogsHandler.disposed()

          expect(controller.delete).not.toHaveBeenCalled()

  describe "controller", ->

    describe "controller.delete", ->
      collection = null
      alerts = null

      beforeEach inject ($injector) ->
        alerts = $injector.get("alerts")

        collection = dbName: "test_database", name: "dummy-collection-id"
        $httpBackend.whenDELETE("/api/databases/test_database/collections/dummy-collection-id.json")
          .respond(true)

        controller.delete(collection)

      it "sends a delete request", ->
        $httpBackend.flush()

      it "displays a flash message", ->
        spyOn(alerts, "info")
        $httpBackend.flush()
        expect(alerts.info).toHaveBeenCalledWith("Collection dummy-collection-id has been deleted.")
