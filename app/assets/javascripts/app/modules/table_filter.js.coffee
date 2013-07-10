taleFilter = angular.module("mb.tableFilter", [])

class TableFilterCtrl
  constructor: ($scope) ->
    # Clears the filter value
    $scope.clear = -> $scope.value = ""

    # Reruns true when the filter is empty
    $scope.isEmpty = -> !$scope.value

TableFilterCtrl.$inject = ["$scope"]

taleFilter.controller "tableFilter", TableFilterCtrl

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
