angular.module "mb.resources", ["ngResource", "mb.filters"], ($provide) ->

  $provide.factory "Database", [
    "$resource", (resource) ->

      resource "/api/databases.json", {},
        query: method: "GET", isArray: true
  ]

  $provide.factory "Collection", [
    "$resource", "$filter", (resource, $filter) ->

      resource "/api#{$filter("collectionsPath")()}.json", {},
        query: method: "GET", isArray: true
  ]

  $provide.factory "Document", [
    "$resource", "$filter", (resource, $filter) ->

      resource "/api#{$filter("documentsPath")()}.json", {},
        query: method: "GET", isArray: false
  ]
