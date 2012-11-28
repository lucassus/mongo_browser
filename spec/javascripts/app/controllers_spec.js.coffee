# TODO figure out how to dry specs for #delete methods

describe "controllers", ->
  beforeEach module("mb.services")
  beforeEach module("mocks")

  $httpBackend = null

  beforeEach inject ($injector) ->
    $httpBackend = $injector.get('$httpBackend')

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "DatabasesCtrl", ->
    $scope = null
    doAction = null

    beforeEach inject ($injector, $rootScope, $controller) ->
      $scope = $rootScope.$new()
      doAction = jasmine.createSpy("do action")

      $httpBackend.when("GET", "/databases.json").respond([])
      $controller window.DatabasesCtrl,
        $scope: $scope
        doAction: doAction

      $httpBackend.flush()

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

  describe "CollectionsCtrl", ->
    $scope = null
    doAction = null

    beforeEach inject ($injector, $rootScope, $controller) ->
      $scope = $rootScope.$new()
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

  describe "DocumentsCtrl", ->
    $scope = null
    doAction = null

    beforeEach inject ($injector, $rootScope, $controller) ->
      $scope = $rootScope.$new()
      confirmationDialog = $injector.get("confirmationDialog")
      doAction = jasmine.createSpy("do action")

      $element = $("<div/>")
          .data("db-name", "test_database")
          .data("collection-name", "test_collection")

      $controller window.DocumentsCtrl,
          $scope: $scope
          $element: $element
          confirmationDialog: confirmationDialog
          doAction: doAction

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
