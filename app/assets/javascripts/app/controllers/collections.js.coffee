module = angular.module("mb.controllers")

# TODO clenup this controller, see DatabasesController
class CollectionsController
  @$inject = ["$scope", "$routeParams",
              "Database", "Collection", "$http", "confirmationDialog", "alerts"]
  constructor: (@$scope, @$routeParams, @Database, @Collection, @$http, @confirmationDialog, @alerts) ->
    @$scope.dbName = @$routeParams.dbName
    @$scope.filterValue = ""

    _onLoadComplete = (data) =>
      @$scope.collections = data
      @$scope.loading = false

    @$scope.fetchCollections = =>
      @$scope.loading = true
      params = dbName: @$scope.dbName
      @$scope.collections = @Collection.query(params, _onLoadComplete)

    @$scope.fetchCollections()

    new @Database(name: @$scope.dbName).$stats (data) =>
      @$scope.dbStats = data

    @$scope.isLoading = => @$scope.loading

    @$scope.delete = (data) =>
      @confirmationDialog
        message: "Deleting #{data.name}. Are you sure?"
        onOk: =>
          collection = new @Collection(data)
          collection.$delete =>
            @alerts.info("Collection #{data.name} has been deleted.")
            @$scope.fetchCollections()

module.controller "collections", CollectionsController
