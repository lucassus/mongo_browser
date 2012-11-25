module = angular.module("mb.directives", [])

# Handles ESC key
module.directive "onEsc", ->
  EscapeCode = 27

  ($scope, $element, attrs) ->
    $element.bind "keyup", (event) ->
      return unless event.keyCode is EscapeCode
      $scope.$apply(attrs.onEsc)

# Filter for databases and collections
module.directive "filter", ->
  template: $("#filter-template").text()
  restrict: "E"
  replace: true
  transclude: true
  controller: ($scope) ->
    $scope.clear = -> $scope.value = ""
    # Initially clear the filter
    $scope.clear()
  scope:
    placeholder: "@placeholder"

  link: ($scope, $element) ->
    $scope.$watch "value", (value) ->
      $scope.$emit("FilterChange", value)

      $clearButton = $element.find("button")
      if value is ""
        $clearButton.addClass("disabled")
      else
        $clearButton.removeClass("disabled")
