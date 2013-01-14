describe "mb.spinner", ->
  beforeEach module("mb.spinner")

  describe "httpRequestTracker", ->
    $http = null
    httpRequestTracker = null

    beforeEach inject ($injector) ->
      httpRequestTracker = $injector.get("httpRequestTracker")
      $http = $injector.get("$http")

    it "should not report pending requests if no requests in progress", ->
      expect(httpRequestTracker.hasPendingRequests()).toBeFalsy()

    it "should report pending requests if requests are in progress", ->
      $http.pendingRequests.push {}
      expect(httpRequestTracker.hasPendingRequests()).toBeTruthy()

  describe "controller", ->
    httpRequestTracker = null
    controller = null
    $scope = null

    beforeEach inject ($injector, $rootScope, $controller) ->
      httpRequestTracker = $injector.get("httpRequestTracker")
      $scope = $rootScope.$new()
      controller = $controller "spinner",
        $scope: $scope

    describe "#showSpinner", ->
      describe "when there is a pending request", ->
        beforeEach ->
          spyOn(httpRequestTracker, "hasPendingRequests").andReturn(true)

        it "returns true", ->
          expect($scope.showSpinner()).toBeTruthy()

      describe "otherwise", ->
        beforeEach ->
          spyOn(httpRequestTracker, "hasPendingRequests").andReturn(false)

        it "returns false", ->
          expect($scope.showSpinner()).toBeFalsy()

  describe "directive", ->
    element = null

    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope
      $scope.showSpinner = -> false

      element = angular.element """
      <spinner></spinner>
      """
      $compile(element)($scope)
      $scope.$digest()

    it "renders the spinner", ->
      img = element.find("img")

      expect(img.length).toBe(1)
      expect(img.attr("src")).toEqual("/assets/ajax-loader.gif")
