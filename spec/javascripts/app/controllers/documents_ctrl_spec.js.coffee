describe "DocumentsCtrl", ->
  beforeEach module("mb.services")
  beforeEach module("mocks")

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