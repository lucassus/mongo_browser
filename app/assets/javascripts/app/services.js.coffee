module = angular.module("mb.services", []).
  value("version", "0.1")

module.factory "tableFilterFactory", ($filter) ->
  (scope, collectionName) ->
    collectionCopy: angular.copy(scope[collectionName])
    filter: (value) ->
      scope[collectionName] = $filter("filter")(@collectionCopy, value)
    noMatches: ->
      scope[collectionName].length is 0
