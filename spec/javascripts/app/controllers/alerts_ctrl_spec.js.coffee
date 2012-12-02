describe "AlertsCtrl", ->
  beforeEach module("mb.services")

  $scope = null
  alerts = null

  beforeEach inject ($injector, $rootScope, $controller) ->
    $scope = $rootScope.$new()

    alerts = $injector.get("alerts")

    $controller window.AlertsCtrl,
      $scope: $scope,
      alerts: alerts

  it "assings flash messages", ->
    expect($scope.alertMessages).toBeDefined()
    expect($scope.alertMessages).toEqual([])

    alerts.info("Test message.")
    expect($scope.alertMessages).toContain(type: "info", text: "Test message.")

  describe "#disposeAlert", ->
    it "disposes an alert at the given index", ->
      # Given
      alerts.info("Information..")
      alerts.error("Error..")
      spyOn(alerts, "dispose").andCallThrough()

      # When
      $scope.disposeAlert(1)

      # Then
      expect(alerts.dispose).toHaveBeenCalledWith(1)
      expect($scope.alertMessages).toContain(type: "info", text: "Information..")
      expect($scope.alertMessages).not.toContain(type: "error", text: "Error..")
