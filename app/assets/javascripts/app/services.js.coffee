module = angular.module("mb.services", [])

module.factory "tableFilterFactory", ($filter) ->
  (scope, collectionName) ->
    collectionCopy: angular.copy(scope[collectionName])

    filter: (value) ->
      scope[collectionName] = $filter("filter")(@collectionCopy, value)

    matchesCount: ->
      scope[collectionName].length

    noMatches: ->
      @matchesCount() is 0
