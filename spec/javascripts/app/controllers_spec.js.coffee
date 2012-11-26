describe "controllers", ->
  beforeEach module("mb.services")

  # Create mock for dialogsHandler
  beforeEach ->
    angular.module("mock", []).config ($provide) ->
      $provide.factory "dialogsHandler", ->
        confirm: (message, callback) ->
          @callback = callback
        confirmed: -> @callback(true)
        disposed: -> @callback(false)

  beforeEach module("mock")

  describe "DocumentsCtrl", ->
    ctrl = null
    $scope = null
    confirmationDialog = null
    doAction = null

    beforeEach inject ($injector, $rootScope, $controller) ->
      $scope = $rootScope.$new()
      confirmationDialog = $injector.get("confirmationDialog")
      doAction = jasmine.createSpy("do action")

      $element = $("<div/>")
          .data("db-name", "test_database")
          .data("collection-name", "test_collection")

      ctrl = $controller window.DocumentsCtrl,
        $scope: $scope
        $element: $element
        confirmationDialog: confirmationDialog
        doAction: doAction

    it "is defined", ->
      expect(ctrl).toBeDefined()

    describe "#delete", ->
      it "shows confirmation dialog", inject (dialogsHandler) ->
        spyOn(dialogsHandler, "confirm")
        $scope.delete("dummy-document-id")
        expect(dialogsHandler.confirm).toHaveBeenCalledWith \
            "Are you sure?",
            jasmine.any(Function)

      describe "when the dialog was confirmed", ->
        it "sends a delete request", inject (dialogsHandler) ->
          # When
          $scope.delete("dummy-document-id")
          dialogsHandler.confirmed()

          # Then
          expect(doAction).toHaveBeenCalledWith \
              "/databases/test_database/collections/test_collection/dummy-document-id",
              "delete"

      describe "when the dialog was disposed", ->
        it "does nothing", inject (dialogsHandler) ->
          # When
          $scope.delete("dummy-document-id")
          dialogsHandler.disposed()

          # Then
          expect(doAction).not.toHaveBeenCalled()
