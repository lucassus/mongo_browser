module = angular.module("mb.controllers")

# TODO clenup this controller, see DatabasesController
class CollectionsController
  @$inject = ["$scope", "$routeParams",
              "Collection", "$http", "confirmationDialog", "alerts"]
  constructor: (@$scope, @$routeParams, @Collection, @$http, @confirmationDialog, @alerts) ->
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

    # TODO create resource for this call
    @$http.get("/api/databases/#{@$scope.dbName}/stats.json").success (data) =>
      @$scope.dbStats = data

    @$scope.isLoading = => @$scope.loading

    @$scope.delete = (collection) =>
      @confirmationDialog
        message: "Deleting #{collection.name}. Are you sure?"
        onOk: =>
          resource = new @Collection()
          params = dbName: collection.dbName, collectionName: collection.name

          resource.$delete params, =>
            @alerts.info("Collection #{collection.name} has been deleted.")
            @$scope.fetchCollections()

module.controller "collections", CollectionsController
