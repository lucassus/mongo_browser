class DocumentsShowCtrl
  @$inject = ["$scope", "$routeParams", "$location", "Document", "alerts"]
  constructor: ($scope, $routeParams, @$location, Document, @alerts) ->
    @loading = false

    { @dbName, @collectionName, @id } = $routeParams
    @document = new Document(dbName: @dbName, collectionName: @collectionName, id: @id)

    # Scope variables
    $scope.dbName = @dbName
    $scope.collectionName = @collectionName
    $scope.document = @document

    # Scope methods
    $scope.isLoading = => @loading
    $scope.refresh = => @refreshDocument()

    @fetchDocument =>
      @loading = false

  fetchDocument: (onSuccess = ->) ->
    @loading = true
    @document.$get(onSuccess, @handleNotFoundDocument)

  refreshDocument: ->
    @fetchDocument =>
      @loading = false
      @alerts.info("Document was refreshed")

  # Redirects to the collection page
  # alert.error will be set by the `httpErrorsInterceptor`
  handleNotFoundDocument: (response) =>
    return unless response.status is 404
    # TODO use filter here
    @$location.path("/databases/#{@dbName}/collections/#{@collectionName}/documents")

angular.module("mb")
  .controller("documents.show", DocumentsShowCtrl)
