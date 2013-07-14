class CollectionsIndexCtrl
  @$inject = ["$scope", "$routeParams", "Collection", "confirmationDialog", "alerts"]
  constructor: (@$scope, $routeParams, @Collection, @confirmationDialog, @alerts) ->
    @loading = false
    { @dbName } = $routeParams

    # Scope variables
    @$scope.dbName = @dbName
    @$scope.filterValue = ""

    # Scope methods
    @$scope.isLoading = => @loading
    @$scope.delete = (collection) => @deleteWithConfirmation(collection)

    @fetchCollections()

  fetchCollections: ->
    @loading = true
    params = dbName: @dbName
    @$scope.collections = @Collection.query(params, @onLoadComplete)

  onLoadComplete: (data) =>
    @$scope.collections = data
    @loading = false

  deleteWithConfirmation: (collection) ->
    @confirmationDialog
      message: "Deleting #{collection.name}. Are you sure?"
      onOk: => @delete(collection)

  delete: (data) ->
    collection = new @Collection(data)
    collection.$delete =>
      @alerts.info("Collection #{data.name} has been deleted.")
      @fetchCollections()

angular.module("mb")
  .controller("collections.index", CollectionsIndexCtrl)
