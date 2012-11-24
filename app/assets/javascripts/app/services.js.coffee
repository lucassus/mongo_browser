module = angular.module("mongoBrowserServices", [])

module.factory "tableFilterFactory", ($filter) ->
  (scope, collectionName) ->
    collectionCopy: angular.copy(scope[collectionName])
    filter: (value) ->
      scope[collectionName] = $filter("filter")(@collectionCopy, value)
    noMatches: ->
      scope[collectionName].length is 0
