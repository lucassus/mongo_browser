class ServersShowCtrl
  @$inject = ["$scope", "$http"]
  constructor: (@$scope, @$http) ->
    @loading = true
    @fetchServerInfo()

    $scope.isLoading = => @loading

  fetchServerInfo: ->
    @$http.get("/api/server_info").success(@onLoadComplete)

  onLoadComplete: (data) =>
    @$scope.serverInfo = data
    @loading = false

angular.module("mb")
  .controller("servers.show", ServersShowCtrl)
