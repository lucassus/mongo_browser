angular.module "mb.resources", ["ngResource", "mb.filters"], ($provide) ->

  $provide.factory "Database", [
    "$resource", ($resource) ->

      $resource "/api/databases/:dbName.json", {},
        query: method: "GET", isArray: true
  ]

  $provide.factory "Collection", [
    "$resource", "$filter", ($resource, $filter) ->

      $resource "/api#{$filter("collectionsPath")()}/:collectionName.json", {},
        query: method: "GET", isArray: true
  ]

  $provide.factory "Document", [
    "$resource", "$filter", ($resource, $filter) ->

      $resource "/api#{$filter("documentsPath")()}/:id.json", {},
        query: method: "GET", isArray: false
  ]
