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

# TODO this is only a prototype
module.directive "pager", ->
  templateUrl: "/ng/templates/pager.html"
  restrict: "E"
  replace: true
  transclude: true

  scope:
    page: "=page"
    totalPages: "=totalPages"

  controller: ($scope, pager) ->
    paginate = ->
      prepare = pager(page: $scope.page, totalPages: $scope.totalPages)
      $scope.windowedPageNumbers = prepare.windowedPageNumbers()

    $scope.$watch "page", ->
      paginate()

    $scope.setPage = (page) ->
      return if page < 1 or page > $scope.totalPages
      $scope.page = page

    $scope.next = ->
      $scope.page += 1 if $scope.hasNext()

    $scope.hasNext = ->
      $scope.page < $scope.totalPages

    $scope.prev = ->
      $scope.page -= 1 if $scope.hasPrev()

    $scope.hasPrev = ->
      $scope.page > 1

  link: ($scope, $element) ->
