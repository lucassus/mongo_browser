module = angular.module("mb.controllers")

# TODO clenup this controller, see DatabasesController
class DocumentsController
  constructor: (@$scope, @$routeParams, @$http, @Document, @confirmationDialog, @alerts) ->
    @$scope.dbName = @$routeParams.dbName
    @$scope.collectionName = @$routeParams.collectionName

    @$scope.isLoading = => @$scope.loading

    _onLoadComplete = (data) =>
      @$scope.loading = false

      @$scope.documents = data.documents
      @$scope.page = data.page
      @$scope.totalPages = data.totalPages
      @$scope.size = data.size

    @$scope.fetchDocuments = (page = 1) =>
      return if @$scope.isLoading() # TODO workaround for doule request
      @$scope.loading = true

      params = dbName: @$scope.dbName, collectionName: @$scope.collectionName, page: page
      @Document.query(params, _onLoadComplete)

    @$scope.page = 1
    @$scope.fetchDocuments()

    @$scope.$watch "page", (page) =>
      @$scope.fetchDocuments(page)

    # TODO create resource for this call
    @$http.get("/api/databases/#{@$scope.dbName}/collections/#{@$scope.collectionName}/stats.json").success (data) =>
      @$scope.collectionStats = data

    @$scope.delete = (document) =>
      @confirmationDialog
        message: "Are you sure?"
        onOk: =>
          resource = new @Document()
          params = dbName: @$scope.dbName, collectionName: @$scope.collectionName, id: document.id

          resource.$delete params, =>
            @alerts.info("Document #{document.id} has been deleted.")
            @$scope.fetchDocuments()

DocumentsController.$inject = ["$scope", "$routeParams", "$http", "Document", "confirmationDialog", "alerts"]

module.controller "documents", DocumentsController
