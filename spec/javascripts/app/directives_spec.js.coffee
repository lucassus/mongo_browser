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
      $scope = $rootScope

      element = $compile('<filter value="filterValue" placeholder="Enter database name"></filter>')($scope)
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

  describe "tabs controller", ->
    $scope = null

    beforeEach inject ($rootScope, $controller) ->
      $scope = $rootScope.$new()

      $controller("tabs", $scope: $scope)

    describe "#addPane", ->
      it "appends the given pane", ->
        # Given
        pane = { name: "One" }
        secondPane = { name: "Two" }

        # When
        $scope.addPane(pane)

        # Then
        expect($scope.panes).toContain(pane)
        expect($scope.panes).not.toContain(secondPane)

        # When
        $scope.addPane(secondPane)
        $scope.addPane(secondPane)

        # Then
        expect($scope.panes).toContain(pane)
        expect($scope.panes).toContain(secondPane)

      it "selects the first one", ->
        # Given
        pane = { name: "One" }
        secondPane = { name: "Two" }

        # When
        $scope.addPane(pane)
        $scope.addPane(secondPane)

        # Then
        expect(pane.selected).toBeTruthy()
        expect(secondPane.selected).toBeFalsy()

    describe "#select", ->
      it "marks the given pane as selected", ->
        pane = { name: "One" }
        $scope.select(pane)
        expect(pane.selected).toBeTruthy()

      it "deselects other panes", ->
        # Given
        pane = { name: "One" }
        secondPane = { "Two" }
        thirdPage = { "Three" }

        $scope.addPane(pane)
        $scope.addPane(secondPane)
        $scope.addPane(thirdPage)

        expect(pane.selected).toBeTruthy()

        # When
        $scope.select(secondPane)

        # Then
        expect(pane.selected).toBeFalsy()
        expect(secondPane.selected).toBeTruthy()
        expect(thirdPage.selected).toBeFalsy()

        # When
        $scope.select(thirdPage)

        # Then
        expect(pane.selected).toBeFalsy()
        expect(secondPane.selected).toBeFalsy()
        expect(thirdPage.selected).toBeTruthy()
