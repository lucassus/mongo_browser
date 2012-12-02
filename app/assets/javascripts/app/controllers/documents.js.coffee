module = angular.module("mb.controllers")

module.controller "documents", ($scope, $routeParams, $http, Document, confirmationDialog, alerts) ->
  $scope.dbName = $routeParams.dbName
  $scope.collectionName = $routeParams.collectionName

  _onLoadComplete = (data) ->
    $scope.loading = false

  $scope.fetchDocuments = ->
    $scope.loading = true

    params = dbName: $scope.dbName, collectionName: $scope.collectionName
    $scope.documents = Document.query(params, _onLoadComplete())

  $scope.fetchDocuments()

  $scope.page = 1
  $scope.totalPages = 99

  $scope.$watch "page", (page) ->
    console.log("New page", page)
    $scope.fetchDocuments()

  # TODO create resource for this call
  $http.get("/api/databases/#{$scope.dbName}/collections/#{$scope.collectionName}/stats.json").success (data) ->
    $scope.collectionStats = data

  $scope.delete = (document) ->
    confirmationDialog
      message: "Are you sure?"
      onOk: ->
        resource = new Document()
        params = dbName: $scope.dbName, collectionName: $scope.collectionName, id: document.id

        resource.$delete params, ->
          alerts.info("Document #{document.id} has been deleted.")
          $scope.fetchDocuments()
