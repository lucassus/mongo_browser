describe "directives", ->
  beforeEach module("mb.directives")

  describe "osEsc", ->
    $scope = null
    element = null

    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope.$new()
      $scope.bar = ->

      element = $compile('<input type="text" on-esc="bar()" />')($scope)
      $scope.$digest()

      spyOn($scope, 'bar')

    it "calls the given function when the ESC was pressed", ->
      event = jQuery.Event("keyup", keyCode: 27)
      element.trigger(event)

      expect($scope.bar).toHaveBeenCalled()

    it "does nothing on other keys", ->
      event = jQuery.Event("keyup", keyCode: 13)
      element.trigger(event)

      expect($scope.bar).not.toHaveBeenCalled()

  describe "filter controller", ->
    $scope = null

    beforeEach inject ($controller, $rootScope) ->
      $scope = $rootScope.$new()
      $controller("filter", $scope: $scope)

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

  describe "filter", ->
    $scope = null
    element = null

    beforeEach module("app/assets/templates/filter.html")

    beforeEach inject ($rootScope, $compile) ->
      element = angular.element('<filter value="filterValue" placeholder="Enter database name"></filter>')

      $scope = $rootScope
      $compile(element)($scope)
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
