describe "mb.alerts", ->
  beforeEach module("mb.alerts")

  describe "controller", ->
    $scope = null
    alerts = null

    beforeEach inject ($injector, $rootScope, $controller) ->
      $scope = $rootScope.$new()

      alerts = $injector.get("alerts")

      $controller "alerts",
        $scope: $scope,
        alerts: alerts

    it "assings flash messages", ->
      expect($scope.alertMessages).toBeDefined()
      expect($scope.alertMessages).toEqual([])

      alerts.info("Test message.")
      expect($scope.alertMessages).toContain(id: 1, type: "info", text: "Test message.")

    describe "#disposeAlert", ->
      it "disposes an alert at the given index", ->
        # Given
        alerts.info("Information..")
        alerts.error("Error..")
        spyOn(alerts, "dispose").andCallThrough()

        # When
        $scope.disposeAlert(2)

        # Then
        expect(alerts.dispose).toHaveBeenCalledWith(2)
        expect($scope.alertMessages).toContain(id: 1, type: "info", text: "Information..")
        expect($scope.alertMessages).not.toContain(id: 2, type: "error", text: "Error..")

  describe "directive", ->
    $scope = null
    element = null

    beforeEach module("app/assets/templates/alerts.html")

    beforeEach inject ($rootScope, $compile) ->
      $scope = $rootScope

      tpl = "<alerts></alerts>"
      element = $compile(tpl)($scope)
      $scope.$digest()

    it "renders alerts", ->
      $scope.$apply -> $scope.alertMessages = [type: "info", text: "Test message"]
      expect(element.find(".alert-info").length).toEqual(1)

  describe "service", ->
    it "is defined", inject (alerts) ->
      expect(alerts).toBeDefined()

    describe "#nextId", ->
      it "return the next id for the new flash message", inject (alerts) ->
        expect(alerts.nextId()).toEqual(1)
        _(4).times -> alerts.nextId()
        expect(alerts.nextId()).toEqual(6)

    describe "#push", ->
      beforeEach inject (alerts) ->
        spyOn(alerts, "delayedDispose")

      it "returns an id for the new flash message", inject (alerts) ->
        expect(alerts.push("info", "Test..")).toEqual(1)
        expect(alerts.delayedDispose).toHaveBeenCalledWith(1)

        expect(alerts.push("error", "Test error..")).toEqual(2)
        expect(alerts.delayedDispose).toHaveBeenCalledWith(2)

      describe "#info", ->
        it "pushesh the given message", inject (alerts) ->
          # Given
          testMessage = "This is a test message!"
          otherTestMessage = "This is a second test message!"

          # When
          alerts.info(testMessage)
          expect(alerts.delayedDispose).toHaveBeenCalledWith(1)

          alerts.info(otherTestMessage)
          expect(alerts.delayedDispose).toHaveBeenCalledWith(2)

          # Then
          expect(alerts.messages).toContain(id: 1, type: "info", text: testMessage)
          expect(alerts.messages).toContain(id: 2, type: "info", text: otherTestMessage)

      describe "#error", ->
        it "pushesh the given message", inject (alerts) ->
          # Given
          testMessage = "This is a test message!"

          # When
          alerts.error(testMessage)
          expect(alerts.delayedDispose).toHaveBeenCalledWith(1)

          # Then
          expect(alerts.messages).toContain(id: 1, type: "error", text: testMessage)

    describe "#dispose", ->
      it "removes a message with the given id", inject (alerts) ->
        # Given
        alerts.info("First message")
        alerts.info("Second message")
        alerts.info("Third message")
        alerts.error("Error message")

        # When
        alerts.dispose(2)

        # Then
        expect(alerts.messages).toContain(id: 1, type: "info", text: "First message")
        expect(alerts.messages).not.toContain(id: 2, type: "info", text: "Second message")
        expect(alerts.messages).toContain(id: 3, type: "info", text: "Third message")
        expect(alerts.messages).toContain(id: 4, type: "error", text: "Error message")

    describe "#delayedDispose", ->
      it "removes a message after the given time", inject (alerts, $timeout) ->
        # Given
        alerts.info("First message")

        # When
        alerts.delayedDispose(1)
        expect(alerts.messages).toContain(id: 1, type: "info", text: "First message")

        $timeout.flush()

        # Then
        expect(alerts.messages).toEqual([])
