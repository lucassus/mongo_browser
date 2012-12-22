angular.module("mb")
  .config [
    "$provide", ($provide) ->
      $provide.value("alertTimeout", null)
  ]
