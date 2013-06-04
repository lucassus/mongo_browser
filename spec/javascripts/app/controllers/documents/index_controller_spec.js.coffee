describe "documents index controller", ->
  beforeEach module("mb.controllers")
  beforeEach module("mb.dialogs")
  beforeEach module("mb.alerts")
  beforeEach module("mocks")

  controller = null
  $scope = null

  $httpBackend = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    alerts = $injector.get("alerts")

    $routeParams = $injector.get("$routeParams")
    $routeParams.dbName = "test_database"
    $routeParams.collectionName = "test_collection"

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.whenGET("/api/databases/test_database/collections/test_collection/documents?page=1")
      .respond([])

    $scope = $rootScope.$new()
    controller = $controller "documents.index",
      $scope: $scope

    $scope.$digest()
    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "$scope", ->

    describe "$scope.showDocuments", ->
      it "returns true when the collection size is > 0", ->
        $scope.size = 1
        expect($scope.showDocuments()).toBeTruthy()

      it "return false when the collection size is 0", ->
        $scope.size = 0
        expect($scope.showDocuments()).toBeFalsy()

    describe "$scope.isLoading", ->
      it "returns true when the resouce it loading", ->
        controller.loading = true
        expect($scope.isLoading()).toBeTruthy()

      it "otherwise returns false", ->
        controller.loading = false
        expect($scope.isLoading()).toBeFalsy()

    describe "$scope.delete", ->
      document = null
      dialogsHandler = null

      beforeEach inject ($injector) ->
        dialogsHandler = $injector.get("dialogsHandler")
        document = {}

      it "shows the confirmation dialog", ->
        spyOn(dialogsHandler, "confirm")
        $scope.delete(document)

        expect(dialogsHandler.confirm).toHaveBeenCalledWith "Are you sure?",
          jasmine.any(Function)

      describe "when the dialog was confirmed", ->
        it "calls delete method", ->
          spyOn(controller, "deleteWithConfirmation").andCallThrough()
          spyOn(controller, "delete")

          $scope.delete(document)
          dialogsHandler.confirmed()

          expect(controller.deleteWithConfirmation).toHaveBeenCalledWith(document)
          expect(controller.delete).toHaveBeenCalledWith(document)

      describe "when the dialog was disposed", ->
        it "does nothing", ->
          spyOn(controller, "delete")

          $scope.delete(document)
          dialogsHandler.disposed()

          expect(controller.delete).not.toHaveBeenCalled()

  describe "controller", ->

    describe "controller.delete", ->
      document = null
      alerts = null

      beforeEach inject ($injector) ->
        alerts = $injector.get("alerts")

        document = id: "document-id"
        $httpBackend.whenDELETE("/api/databases/test_database/collections/test_collection/documents/document-id")
          .respond(true)

        controller.delete(document)

      it "sends a delete request", ->
        $httpBackend.flush()

      it "displays a flash message", ->
        spyOn(alerts, "info")
        $httpBackend.flush()
        expect(alerts.info).toHaveBeenCalledWith("Document document-id has been deleted.")
