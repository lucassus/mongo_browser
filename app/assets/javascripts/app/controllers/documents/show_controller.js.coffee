module = angular.module("mb.controllers")

class DocumentsShowController
  @$inject = ["$scope", "$routeParams", "Document"]
  constructor: (@$scope, $routeParams, @Document) ->
    @loading = false

    # Scope variables
    @$scope.dbName = $routeParams.dbName
    @$scope.collectionName = $routeParams.collectionName
    @$scope.id = $routeParams.id

    # Scope methods
    @$scope.isLoading = => @loading

    @fetchDocument()

  fetchDocument: ->
    @loading = true
    @$scope.document = new @Document(dbName: @$scope.dbName, collectionName: @$scope.collectionName, id: @$scope.id, data: {})
    @$scope.document.$get =>
      @loading = false

module.controller "documents.show", DocumentsShowController
