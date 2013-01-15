module = angular.module("mb.controllers")

class DocumentsShowController
  @$inject = ["$scope", "$routeParams", "$location", "Document"]
  constructor: ($scope, $routeParams, @$location, Document) ->
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
    onSuccess = => @loading = false
    @document.$get(onSuccess, @handleNotFoundDocument)

  handleNotFoundDocument: (response) =>
    return unless response.status is 404
    @$location.path("/databases/#{@dbName}/collections/#{@collectionName}/documents")

module.controller "documents.show", DocumentsShowController
