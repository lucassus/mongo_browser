describe "documents show controller", ->
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
    $routeParams.id = "document_id"

    $httpBackend = $injector.get("$httpBackend")
    $httpBackend.whenGET("/api/databases/test_database/collections/test_collection/documents/document_id.json")
      .respond({})

    $scope = $rootScope.$new()
    controller = $controller "documents.show",
      $scope: $scope

    $scope.$digest()
    $httpBackend.flush()

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "$scope", ->
    it "assigns variables from $routeParams", ->
      expect($scope.dbName).toEqual("test_database")
      expect($scope.collectionName).toEqual("test_collection")

    # TODO create a macro / shared examples
    describe "$scope.isLoading", ->
      it "returns true when the resouce it loading", ->
        controller.loading = true
        expect($scope.isLoading()).toBeTruthy()

      it "otherwise returns false", ->
        controller.loading = false
        expect($scope.isLoading()).toBeFalsy()

  describe "controller", ->
    describe "controller.handleNotFoundDocument", ->
      $location = null

      beforeEach inject ($injector) ->
        $location = $injector.get("$location")
        spyOn($location, "path")

      describe "when the response status is 404", ->
        it "redirects to the documents list page", ->
          controller.handleNotFoundDocument(status: 404)
          expect($location.path).toHaveBeenCalledWith("/databases/test_database/collections/test_collection/documents")

      describe "when the rsponse status is not 404", ->
        it "should not redirect", ->
          controller.handleNotFoundDocument(status: 500)
          expect($location.path).not.toHaveBeenCalled()
