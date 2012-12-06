describe "mb.tableFilter", ->
  beforeEach module("mb.tableFilter")

  describe "tableFilter controller", ->
    $scope = null

    beforeEach inject ($controller, $rootScope) ->
      $scope = $rootScope.$new()
      $controller("tableFilter", $scope: $scope)

    describe "#isEmpty", ->
      it "returns true when the value is empty", ->
        for value in [null, undefined, ""]
          $scope.value = value
          expect($scope.isEmpty()).toBeTruthy()

      it "returs false when the value is not empty", ->
        $scope.value = "foo"
        expect($scope.isEmpty()).toBeFalsy()

    describe "#clear", ->
      it "clears the filter value", ->
        $scope.value = "foo"
        $scope.clear()

        expect($scope.value).toEqual("")

  describe "tableFilter", ->
    $scope = null
    element = null

    beforeEach module("app/assets/templates/table_filter.html")

    beforeEach inject ($rootScope, $compile) ->
      $scope = $rootScope

      tpl = """
            <div>
              <table-filter value="filterValue" placeholder="Enter database name"></table-filter>
            </div>
            """
      element = $compile(tpl)($scope)
      $scope.$digest()

    it "sets the valid placeholder", ->
      input = element.find("input[type='text']")
      expect(input.attr('placeholder')).toEqual("Enter database name")

    it "binds the filter value", ->
      $scope.$apply -> $scope.filterValue = "Test filter value"

      input = element.find("input[type='text']")
      expect(input.val()).toEqual("Test filter value")

    describe "the clear button", ->
      button = null

      beforeEach ->
        button = element.find("button")

      it "is initially disabled", ->
        expect(button).toHaveCssClass("disabled")

      describe "when value is not empty", ->
        beforeEach ->
          $scope.$apply -> $scope.filterValue = "some value"

        it "is enabled", ->
          expect(button).not.toHaveCssClass("disabled")

      describe "when the value is empty", ->
        beforeEach ->
          $scope.$apply -> $scope.filterValue = ""

        it "is disabled", ->
          expect(button).toHaveCssClass("disabled")
