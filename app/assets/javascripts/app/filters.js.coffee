module = angular.module("mb.filters", [])

module.filter "humanSize", -> (bytes) ->
  sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB']
  n = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10)
  scaledSize = (bytes / Math.pow(1024, n)).toFixed(0)

  "#{scaledSize} #{sizes[n]}"

module.filter "jsonDocument", -> (document) ->
  str = JSON.stringify(document, undefined, 2)

  syntaxHighlight = (json) ->
    json = json.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
    json.replace /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) ->
      cls = "number"
      if /^"/.test(match)
        if /:$/.test(match)
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
