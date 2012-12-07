module = angular.module("mb.controllers")

module.controller "collections", ($scope, $routeParams, Collection, $http, confirmationDialog, alerts) ->
  $scope.dbName = $routeParams.dbName
  $scope.filterValue = ""

  _onLoadComplete = (data) ->
    $scope.collections = data
    $scope.loading = false

  $scope.fetchCollections = ->
    $scope.loading = true
    $scope.collections = Collection.query({ dbName: $scope.dbName }, _onLoadComplete)

  $scope.fetchCollections()

  # TODO create resource for this call
  $http.get("/api/databases/#{$scope.dbName}/stats.json").success (data) ->
    $scope.dbStats = data

  $scope.isLoading = -> $scope.loading

  $scope.delete = (collection) ->
    confirmationDialog
      message: "Deleting #{collection.name}. Are you sure?"
      onOk: ->
        resource = new Collection()
        params = dbName: collection.dbName, id: collection.name

        resource.$delete params, ->
          alerts.info("Collection #{collection.name} has been deleted.")
          $scope.fetchCollections()
