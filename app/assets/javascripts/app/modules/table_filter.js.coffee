taleFilter = angular.module("mb.tableFilter", [])

class TableFilterController
  constructor: ($scope) ->
    # Clears the filter value
    $scope.clear = -> $scope.value = ""

    # Reruns true when the filter is empty
    $scope.isEmpty = -> !$scope.value

TableFilterController.$inject = ["$scope"]

taleFilter.controller "tableFilter", TableFilterController

# Filter for databases and collections
taleFilter.directive "tableFilter", ->
  restrict: "E"
  transclude: true

  templateUrl: "/ng/templates/table_filter.html"
  replace: true

  scope:
    placeholder: "@placeholder"
    value: "=value"

  controller: "tableFilter"
