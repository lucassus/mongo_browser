module = angular.module("mb.controllers")

class DocumentsShowController
  @$inject = ["$scope", "$routeParams", "Document"]
  constructor: ($scope, $routeParams, Document) ->
    @loading = false

    { @dbName, @collectionName, @id } = $routeParams
    @document = new Document(dbName: @dbName, collectionName: @collectionName, id: @id)

    # Scope variables
    $scope.dbName = @dbName
    $scope.collectionName = @collectionName
    $scope.document = @document

    # Scope methods
    $scope.isLoading = => @loading

    @fetchDocument()

  fetchDocument: ->
    @loading = true
    @document.$get => @loading = false

module.controller "documents.show", DocumentsShowController
