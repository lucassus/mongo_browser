angular.module "mb.resources", ["ngResource"], ($provide) ->

  $provide.factory "Database", [
    "$resource", (resource) ->

      resource "/api/databases.json", {},
        query: method: "GET", isArray: true
  ]

  $provide.factory "Collection", [
    "$resource", (resource) ->

      resource "/api/databases/:dbName/collections.json", {},
        query: method: "GET", isArray: true
  ]

  $provide.factory "Document", [
    "$resource", (resource) ->

      resource "/api/databases/:dbName/collections/:collectionName/documents.json", {},
        query: method: "GET", isArray: true
  ]
