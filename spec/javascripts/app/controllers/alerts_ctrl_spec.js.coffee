describe "alerts", ->
  beforeEach module("mb.controllers")

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
