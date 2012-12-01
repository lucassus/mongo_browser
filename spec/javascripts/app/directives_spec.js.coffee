describe "directives", ->
  beforeEach module("mb.directives")

  describe "osEsc", ->
    $scope = null
    $element = null

    beforeEach inject ($compile, $rootScope) ->
      $scope = $rootScope.$new()
      $scope.bar = ->

      $element = $compile('<input type="text" on-esc="bar()" />')($scope)
      $scope.$digest()

      spyOn($scope, 'bar')

    it "calls the given function when the ESC was pressed", ->
      event = jQuery.Event("keyup", keyCode: 27)
      $element.trigger(event)

      expect($scope.bar).toHaveBeenCalled()

    it "does nothing on other keys", ->
      event = jQuery.Event("keyup", keyCode: 13)
      $element.trigger(event)

      expect($scope.bar).not.toHaveBeenCalled()
