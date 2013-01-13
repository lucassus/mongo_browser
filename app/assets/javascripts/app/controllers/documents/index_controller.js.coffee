module = angular.module("mb.controllers")

class DocumentsIndexController
  @$inject = ["$scope", "$routeParams", "$location",
              "Document", "confirmationDialog", "alerts"]
  constructor: (@$scope, $routeParams, $location, @Document, @confirmationDialog, @alerts) ->
    @loading = false
    { @dbName, @collectionName } = $routeParams

    # Scope variables
    @$scope.dbName = @dbName
    @$scope.collectionName = @collectionName

    @$scope.page = parseInt($location.search().page || 1)

    # Scope methods
    @$scope.delete = (document) => @deleteWithConfirmation(document)
    @$scope.isLoading = => @loading
    @$scope.showDocuments = => @$scope.size > 0

    @$scope.$watch "page", (page) =>
      if page > 1
        $location.search("page", page)
      else
        $location.search("page", null)

      @fetchDocuments(page)

  fetchDocuments: (page = 1) ->
    @loading = true

    params = dbName: @dbName, collectionName: @collectionName, page: page
    @Document.query(params, @onLoadComplete)

  onLoadComplete: (data) =>
    @$scope.documents = data.documents
    @$scope.page = data.page
    @$scope.totalPages = data.totalPages
    @$scope.size = data.size

    @loading = false

  deleteWithConfirmation: (document) ->
    @confirmationDialog
      message: "Are you sure?"
      onOk: => @delete(document)

  delete: (data) ->
    params = dbName: @dbName, collectionName: @collectionName, id: data.id
    document = new @Document(params)
    document.$delete =>
      @alerts.info("Document #{data.id} has been deleted.")
      @fetchDocuments()

module.controller "documents.index", DocumentsIndexController
