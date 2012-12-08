describe "mb.dialogs", ->
  beforeEach module("mb.dialogs")

  describe "dialogsHandler", ->
    beforeEach inject ($window) ->
      $window.bootbox = "dummy bootbox"

    it "by default is set to bootbox", inject (dialogsHandler) ->
      expect(dialogsHandler).toEqual("dummy bootbox")

  describe "confirmationDialog", ->
    beforeEach module("mocks")

    it "is defined", inject (confirmationDialog) ->
      expect(confirmationDialog).toBeDefined()

    it "calls the handler", inject (confirmationDialog, dialogsHandler) ->
      # Given
      spyOn(dialogsHandler, "confirm")

      # When
      confirmationDialog(message: "This is a test message")

      # Then
      expect(dialogsHandler.confirm).toHaveBeenCalledWith \
        "This is a test message",
        jasmine.any(Function)

    describe "when the dialog was confirmed", ->
      it "calls the given #onOk callback", inject (confirmationDialog, dialogsHandler) ->
        # Given
        onOk = jasmine.createSpy("#onOk callback")
        confirmationDialog(onOk: onOk)

        # When
        dialogsHandler.confirmed()

        # Then
        expect(onOk).toHaveBeenCalled()

    describe "when the dialog was disposed", ->
      it "calls the given #onOk callback", inject (confirmationDialog, dialogsHandler) ->
        # Given
        onCancel= jasmine.createSpy("#onCancel callback")
        confirmationDialog(onCancel: onCancel)

        # When
        dialogsHandler.disposed()

        # Then
        expect(onCancel).toHaveBeenCalled()
