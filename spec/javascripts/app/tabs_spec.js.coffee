describe "tabs", ->
  beforeEach module("mb.tabs")

  describe "tabs controller", ->
    $scope = null
    ctrl = null

    beforeEach inject ($rootScope, $controller) ->
      $scope = $rootScope.$new()

      ctrl = $controller("tabs", $scope: $scope)

    describe "#addPane", ->
      it "appends the given pane", ->
        # Given
        pane = { name: "One" }
        secondPane = { name: "Two" }

        # When
        ctrl.addPane(pane)

        # Then
        expect($scope.panes).toContain(pane)
        expect($scope.panes).not.toContain(secondPane)

        # When
        ctrl.addPane(secondPane)
        ctrl.addPane(secondPane)

        # Then
        expect($scope.panes).toContain(pane)
        expect($scope.panes).toContain(secondPane)

      it "selects the first one", ->
        # Given
        pane = { name: "One" }
        secondPane = { name: "Two" }

        # When
        ctrl.addPane(pane)
        ctrl.addPane(secondPane)

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

        ctrl.addPane(pane)
        ctrl.addPane(secondPane)
        ctrl.addPane(thirdPage)

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

  describe "tabs", ->
    $scope = null
    element = null

    beforeEach module("app/assets/templates/tabs.html")
    beforeEach module("app/assets/templates/pane.html")

    beforeEach inject ($rootScope, $compile) ->
      $scope = $rootScope

      tpl = """
            <div>
              <tabs>
                <pane title="First Tab">first content is {{first}}</pane>
                <pane title="Second Tab">second content is {{second}}</pane>
              </tabs>
            </div>
            """
      element = $compile(tpl)($scope)
      $scope.$digest()

    it "binds the content", ->
      contents = element.find('div.tab-content div.tab-pane')

      expect(contents.length).toBe(2)
      expect(contents.eq(0).text()).toBe('first content is ')
      expect(contents.eq(1).text()).toBe('second content is ')

      $scope.$apply ->
        $scope.first = 123
        $scope.second = 456

      expect(contents.eq(0).text()).toBe('first content is 123')
      expect(contents.eq(1).text()).toBe('second content is 456')
