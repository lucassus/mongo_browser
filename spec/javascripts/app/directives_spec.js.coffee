describe "directives", ->
  beforeEach module("mb.directives")

  $scope = null
  element = null

  describe "osEsc", ->
    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope.$new()
      $scope.bar = ->

      element = $compile('<input type="text" on-esc="bar()" />')($scope)
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

  describe "deleteButton", ->
    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope.$new()
      $scope.bar = ->

      template = """
                 <div>
                   <delete-button ng-click="bar()" />
                 </div>
                 """
      element = $compile(template)($scope)
      $scope.$digest()

    it "renders bar button", ->
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
