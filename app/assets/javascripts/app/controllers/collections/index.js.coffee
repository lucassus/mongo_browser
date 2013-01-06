module = angular.module("mb.controllers")

# TODO clenup this controller, see DatabasesController
class CollectionsIndexController
  @$inject = ["$scope", "$routeParams", "Collection", "confirmationDialog", "alerts"]
  constructor: (@$scope, @$routeParams, @Collection, @confirmationDialog, @alerts) ->
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

    @$scope.isLoading = => @$scope.loading

    @$scope.delete = (data) =>
      @confirmationDialog
        message: "Deleting #{data.name}. Are you sure?"
        onOk: =>
          collection = new @Collection(data)
          collection.$delete =>
            @alerts.info("Collection #{data.name} has been deleted.")
            @$scope.fetchCollections()

module.controller "collections.index", CollectionsIndexController
