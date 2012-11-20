FilterCtrl = ($scope) ->
  $scope.value = ""
  $scope.clear = ->
    @value = ""

angular.module('MongoBrowser', [])
  # Handles ESC key
  .directive 'onEsc', ->
    (scope, element, attrs) ->
      element.bind 'keyup', (event) ->
        EscapeCode = 27
        return unless event.keyCode is EscapeCode
        scope.$apply(attrs.onEsc)

  # Filter for databases and collections
  .directive 'filter', ->
    template: $("#filter-template").text()
    restrict: 'E'
    replace: true
    transclude: true
    controller: FilterCtrl
    scope:
      placeholder: "@placeholder"

    link: (scope, element, attrs) ->
      scope.$watch 'value', ->
        scope.$parent.filterValue = scope.value

        $clearButton = element.find("button")
        if scope.value is ""
          $clearButton.addClass("disabled")
        else
          $clearButton.removeClass("disabled")
