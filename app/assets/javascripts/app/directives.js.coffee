module = angular.module("mb.directives", [])

# Handles ESC key
module.directive "onEsc", ->
  EscapeCode = 27

  ($scope, $element, attrs) ->
    $element.bind "keyup", (event) ->
      return unless event.keyCode is EscapeCode
      $scope.$apply(attrs.onEsc)

module.directive "deleteButton", ->
  replace: true
  restrict: "E"
  template: """
            <a class="btn btn-danger">
              <i class="icon-remove-circle"></i>
              Delete
            </a>
            """
