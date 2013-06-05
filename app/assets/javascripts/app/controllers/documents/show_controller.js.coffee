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
    $scope.refresh = =>
      @alerts.info("Document was refreshed")

    @fetchDocument()

  fetchDocument: ->
    @loading = true
    onSuccess = => @loading = false
    @document.$get(onSuccess, @handleNotFoundDocument)

  handleNotFoundDocument: (response) =>
    return unless response.status is 404
    @$location.path("/databases/#{@dbName}/collections/#{@collectionName}/documents")

angular.module("mb")
  .controller("documents.show", DocumentsShowCtrl)
