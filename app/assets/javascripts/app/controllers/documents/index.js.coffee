module = angular.module("mb.controllers")

# TODO clenup this controller, see DatabasesController
class DocumentsIndexController
  @$inject = ["$scope", "$routeParams", "$location",
              "Document", "confirmationDialog", "alerts"]
  constructor: (@$scope, @$routeParams, @$location, @Document, @confirmationDialog, @alerts) ->
    @$scope.dbName = @$routeParams.dbName
    @$scope.collectionName = @$routeParams.collectionName

    @$scope.showDocuments = =>
      @$scope.size > 0

    @$scope.isLoading = => @$scope.loading

    _onLoadComplete = (data) =>
      @$scope.loading = false

      @$scope.documents = data.documents
      @$scope.page = data.page
      @$scope.totalPages = data.totalPages
      @$scope.size = data.size

    @$scope.fetchDocuments = (page = 1) =>
      return if @$scope.isLoading() # TODO workaround for double request
      @$scope.loading = true

      params = dbName: @$scope.dbName, collectionName: @$scope.collectionName, page: page
      @Document.query(params, _onLoadComplete)

    @$scope.page = parseInt(@$location.search().page || 1)

    @$scope.$watch "page", (page) =>
      if page > 1
        @$location.search("page", page)
      else
        @$location.search("page", null)

      @$scope.fetchDocuments(page)

    @$scope.fetchDocuments()

    @$scope.delete = (data) =>
      @confirmationDialog
        message: "Are you sure?"
        onOk: =>
          params = dbName: @$scope.dbName, collectionName: @$scope.collectionName, id: data.id
          document = new @Document(params)
          document.$delete =>
            @alerts.info("Document #{document.id} has been deleted.")
            @$scope.fetchDocuments()

module.controller "documents.index", DocumentsIndexController
