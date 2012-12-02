module = angular.module("mb.directives", ["mb.services"])

# Handles ESC key
module.directive "onEsc", ->
  EscapeCode = 27

  ($scope, $element, attrs) ->
    $element.bind "keyup", (event) ->
      return unless event.keyCode is EscapeCode
      $scope.$apply(attrs.onEsc)

# Filter for databases and collections
module.directive "filter", ($log) ->
  templateUrl: "/ng/templates/filter.html"
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
      $log.info("Filter change", value)
      $scope.$emit("FilterChange", value)

      $clearButton = $element.find("button")
      if value is ""
        $clearButton.addClass("disabled")
      else
        $clearButton.removeClass("disabled")

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
