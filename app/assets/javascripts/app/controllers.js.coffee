@DatabasesCtrl = ($scope, $http, tableFilterFactory, confirmationDialog, doAction) ->

  $scope.loading = true
  $http.get("/databases.json").success (data) ->
    $scope.databases = data
    $scope.tableFilter = tableFilterFactory($scope, "databases")

    $scope.$on "FilterChange", (event, value) ->
      $scope.tableFilter.filter(value)

    $scope.loading = false

  $scope.isLoading = -> $scope.loading

  $scope.delete = (database) ->
    confirmationDialog
      message: "Deleting #{database.name}. Are you sure?"
      onOk: ->
        url = "/databases/#{database.name}"
        doAction(url, "delete")

@CollectionsCtrl = ($scope, $element, $http, tableFilterFactory, confirmationDialog, doAction) ->
  dbName = $element.data("db-name")

  $scope.loading = true
  $http.get("/databases/#{dbName}.json").success (data) ->
    $scope.collections = data
    $scope.tableFilter = tableFilterFactory($scope, "collections")

    $scope.$on "FilterChange", (event, value) ->
      $scope.tableFilter.filter(value)

    $scope.loading = false

  $scope.isLoading = -> $scope.loading

  $scope.delete = (collection) ->
    confirmationDialog
      message: "Deleting #{collection.name}. Are you sure?"
      onOk: ->
        url = "/databases/#{dbName}/collections/#{collection.name}"
        doAction(url, "delete")

@DocumentsCtrl = ($scope, $element, confirmationDialog, doAction) ->
  dbName = $element.data("db-name")
  collectionName = $element.data("collection-name")

  $scope.delete = (id) ->
    confirmationDialog
      message: "Are you sure?"
      onOk: ->
        url = "/databases/#{dbName}/collections/#{collectionName}/#{id}"
        doAction(url, "delete")
