module = angular.module("mb.directives", ["mb.services"])

# Handles ESC key
module.directive "onEsc", ->
  EscapeCode = 27

  ($scope, $element, attrs) ->
    $element.bind "keyup", (event) ->
      return unless event.keyCode is EscapeCode
      $scope.$apply(attrs.onEsc)

module.controller "filter", ($scope, $log) ->
  # Clears the filter value
  $scope.clear = -> $scope.value = ""

  # Reruns true when the filter is empty
  $scope.isEmpty = -> !$scope.value

# Filter for databases and collections
module.directive "filter", ($log) ->
  restrict: "E"
  transclude: true

  templateUrl: "/ng/templates/filter.html"
  replace: true

  scope:
    placeholder: "@placeholder"
    value: "=value"

  controller: "filter"
