module = angular.module("mb.filters", [])

module.filter "humanSize", -> (bytes) ->
  sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB']
  n = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10)
  scaledSize = (bytes / Math.pow(1024, n)).toFixed(0)

  "#{scaledSize} #{sizes[n]}"

module.filter "jsonDocument", -> (document) ->
  str = JSON.stringify(document, undefined, 2)

  # Replace for the ObjectId
  str = str.replace(/_id": {\s+"\$oid":\s+"(\w+)"\s+}/gm, '_id": ObjectId("$1")')

  syntaxHighlight = (json) ->
    json = json.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
    json.replace /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) ->
      cls = "number"
      if /^"/.test(match)
        if /:$/.test(match)
          # Remove quotes from a key
          match = match.replace(/^"/, "").replace(/":$/, ":")

          cls = "key"
        else
          cls = "string"
      else if /true|false/.test(match)
        cls = "boolean"
      else
        cls = "null" if /null/.test(match)

      "<span class=\"#{cls}\">#{match}</span>"

  "<pre>#{syntaxHighlight(str)}</pre>"

module.filter "collectionsPath", ->
  (database = {}) ->
    dbName = database.name || ":dbName"

    "/databases/#{dbName}/collections"

module.filter "documentsPath", (collectionsPathFilter) ->
  (collection = {}) ->
    dbName = collection.dbName || ":dbName"
    collectionName = collection.name || ":collectionName"

    "#{collectionsPathFilter(name: dbName)}/#{collectionName}/documents"

module.filter "documentPath", (documentsPathFilter) ->
  (document = {}) ->
    dbName = document.dbName || ":dbName"
    collectionName = document.collectionName || ":collectionName"
    id = document.id || ":id"

    "#{documentsPathFilter(dbName: dbName, name: collectionName)}/#{id}"

module.filter "documentPrettyTime", ->
  (document) ->
    timestamp = document.id.toString().substring(0, 8)
    new Date(parseInt(timestamp, 16) * 1000).toGMTString()
