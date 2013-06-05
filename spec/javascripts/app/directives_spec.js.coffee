describe "directives", ->
  beforeEach module("mb.directives")

  $scope = null
  element = null

  describe "osEsc", ->
    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope
      $scope.bar = ->

      element = angular.element """
      <input type="text" on-esc="bar()" />
      """
      $compile(element)($scope)
      $scope.$digest()

    it "calls the given function when the ESC was pressed", ->
      spyOn($scope, 'bar')

      event = jQuery.Event("keyup", keyCode: 27)
      element.trigger(event)

      expect($scope.bar).toHaveBeenCalled()

    it "does nothing on other keys", ->
      spyOn($scope, 'bar')

      event = jQuery.Event("keyup", keyCode: 13)
      element.trigger(event)

      expect($scope.bar).not.toHaveBeenCalled()

  describe "showButton", ->
    renderedButton = null

    # TODO use this trick in other places
    compileTemplate = (template, callback = ->) ->
      beforeEach inject ($compile, $rootScope) ->
        element = angular.element(template)

        $compile(element)($rootScope)
        $rootScope.$digest()

        callback(element)

    describe "when a custom label is not provided", ->
      template = """
       <div>
         <show-button path="/foo/bar/biz" />
       </div>
       """

      compileTemplate template, (element) ->
        renderedButton = element.find("a")

      it "renders the button", ->
        expect(renderedButton.length).toBe(1)
        expect(renderedButton.hasClass("btn")).toBeTruthy()
        expect(renderedButton.hasClass("btn-success")).toBeTruthy()

      it "renders the path", ->
        expect(renderedButton.attr("href")).toEqual("/foo/bar/biz")

      it "renders the custom label", ->
        expect(renderedButton.text()).toContain("Show")

    describe "when a custom label is provided", ->
      template = """
       <div>
         <show-button label="Display me the foo" path="/foo/bar" />
       </div>
       """

      compileTemplate template, (element) ->
        renderedButton = element.find("a")

      it "renders the button", ->
        expect(renderedButton.length).toBe(1)
        expect(renderedButton.hasClass("btn")).toBeTruthy()
        expect(renderedButton.hasClass("btn-success")).toBeTruthy()
        expect(renderedButton.attr("href")).toEqual("/foo/bar")

      it "renders the custom label", ->
        expect(renderedButton.text()).toContain("Display me the foo")

  describe "deleteButton", ->
    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope
      $scope.bar = ->

      element = angular.element """
      <div>
        <delete-button ng-click="bar()" />
      </div>
      """
      $compile(element)($scope)
      $scope.$digest()

    it "renders delete button", ->
      button = element.find("a")

      expect(button.length).toBe(1)
      expect(button.hasClass("btn")).toBeTruthy()
      expect(button.hasClass("btn-danger")).toBeTruthy()
      expect(button.text()).toContain("Delete")

    it "ng-click", ->
      spyOn($scope, 'bar')

      button = element.find("button")
      button.click()

      expect($scope.bar).not.toHaveBeenCalled()

  describe "refreshButton", ->
    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope
      $scope.refresh = ->

      element = angular.element """
      <div>
        <refresh-button ng-click="refresh()" />
      </div>
      """
      $compile(element)($scope)
      $scope.$digest()

    it "renders delete button", ->
      button = element.find("a")

      expect(button.length).toBe(1)
      expect(button.hasClass("btn")).toBeTruthy()
      expect(button.text()).toContain("Refresh")

    it "ng-click", ->
      spyOn($scope, "refresh")

      button = element.find("button")
      button.click()

      expect($scope.refresh).not.toHaveBeenCalled()
