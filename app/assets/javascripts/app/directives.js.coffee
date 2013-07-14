module = angular.module("mb.directives", [])

# Handles ESC key
module.directive "onEsc", ->
  EscapeCode = 27

  ($scope, $element, attrs) ->
    $element.bind "keyup", (event) ->
      return unless event.keyCode is EscapeCode
      $scope.$apply(attrs.onEsc)

module.directive "showButton", ->
  replace: true
  restrict: "E"
  scope:
    path: "@path",
    label: "@label"
  template: """
            <a class="btn btn-success" href="{{path}}">
              <i class="icon-th-list"></i>
              {{label || "Show"}}
            </a>
            """

module.directive "deleteButton", ->
  replace: true
  restrict: "E"
  template: """
            <a class="btn btn-danger">
              <i class="icon-remove-circle"></i>
              Delete
            </a>
            """

module.directive "refreshButton", ->
  replace: true
  restrict: "E"
  template: """
            <a class="btn">
              <i class="icon-refresh"></i>
              Refresh
            </a>
            """
