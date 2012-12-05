#= require angular/angular-mocks

angular.module("mbDev", ["mb", "ngMockE2E"]).run ($httpBackend) ->
  databases = [
      name: "first_database", count: 2, size: 123 * 1024 * 1024
    ,
      name: "second_database", count: 3, size: 1024
    ,
      name: "other_db", count: 4, size: 1025
  ]
  $httpBackend.whenGET("/api/databases.json").respond(databases)

  $httpBackend.whenDELETE("/api/databases.json?id=first_database").respond(true)
  $httpBackend.whenDELETE("/api/databases.json?id=second_database").respond(true)

  serverInfo =
    foo: "bar"
  $httpBackend.whenGET("/api/server_info.json").respond(serverInfo)

  collections = []
  $httpBackend.whenGET("/api/databases/first_database/collections.json").respond(collections)

  stats =
    foo: "bar"
  $httpBackend.whenGET("/api/databases/first_database/stats.json").respond(stats)

  $httpBackend.whenGET(/^\/ng\//).passThrough()
