describe "databases index controller", ->
  beforeEach module("mb.controllers")
  beforeEach module("mb.dialogs")
  beforeEach module("mb.alerts")
  beforeEach module("mocks")

  controller = null
  $scope = null

  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    alerts = $injector.get("alerts")

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.whenGET("/api/databases.json").respond([])

    $scope = $rootScope.$new()
    controller = $controller "databases.index",
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
      database = null
      dialogsHandler = null

      beforeEach inject ($injector) ->
        dialogsHandler = $injector.get("dialogsHandler")
        database = name: "test_database"

      it "shows the confirmation dialog", ->
        spyOn(dialogsHandler, "confirm")
        $scope.delete(database)

        expect(dialogsHandler.confirm).toHaveBeenCalledWith "Deleting test_database. Are you sure?",
          jasmine.any(Function)

      describe "when the dialog was confirmed", ->
        it "calls delete method", ->
          spyOn(controller, "dropWithConfirmation").andCallThrough()
          spyOn(controller, "drop")

          $scope.delete(database)
          dialogsHandler.confirmed()

          expect(controller.dropWithConfirmation).toHaveBeenCalledWith(database)
          expect(controller.drop).toHaveBeenCalledWith(database)

      describe "when the dialog was disposed", ->
        it "does nothing", ->
          spyOn(controller, "drop")

          $scope.delete(database)
          dialogsHandler.disposed()

          expect(controller.drop).not.toHaveBeenCalled()

  describe "controller", ->

    describe "controller.drop", ->
      database = null
      alerts = null

      beforeEach inject ($injector) ->
        alerts = $injector.get("alerts")

        database = name: "test_database"
        $httpBackend.whenDELETE("/api/databases/test_database.json")
          .respond(true)

        controller.drop(database)

      it "sends a delete request", ->
        $httpBackend.flush()

      it "displays a flash message", ->
        spyOn(alerts, "info")
        $httpBackend.flush()
        expect(alerts.info).toHaveBeenCalledWith("Database test_database has been deleted.")
