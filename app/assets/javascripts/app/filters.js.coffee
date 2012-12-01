module = angular.module("mb.filters", [])

module.filter "humanSize", ->
  (bytes) ->
    sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB']
    n = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10)
    scaledSize = (bytes / Math.pow(1024, n)).toFixed(0)

    "#{scaledSize} #{sizes[n]}"
