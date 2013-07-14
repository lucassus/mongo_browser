# Configure app module for the test environment
angular.module("mb")
  .config [
    "$provide", ($provide) ->
      $provide.value("alertTimeout", null)
  ]
