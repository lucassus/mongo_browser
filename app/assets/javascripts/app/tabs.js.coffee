tabs = angular.module("mb.tabs", [])

tabs.controller "tabs", ($scope) ->
  $scope.panes = []

  @addPane = (pane) ->
    $scope.select(pane) if $scope.panes.length is 0
    $scope.panes.push(pane)

  $scope.select = (pane) ->
    otherPane.selected = false for otherPane in $scope.panes
    pane.selected = true

tabs.directive "tabs", ->
  restrict: "E"
  transclude: true
  scope: {}
  controller: "tabs"
  templateUrl: "/ng/templates/tabs.html"
  replace: true

tabs.directive "pane", ->
  require: "^tabs"
  restrict: "E"
  transclude: true
  scope: { title: "@" }
  link: (scope, element, attrs, tabsCtrl) ->
    tabsCtrl.addPane(scope)
  templateUrl: "/ng/templates/pane.html"
  replace: true
