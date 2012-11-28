# Create a mock for bootboxDialogsHandler
angular.module("mocks", []).config ($provide) ->
  $provide.factory "bootboxDialogsHandler", ->
    confirm: (message, callback) ->
      @callback = callback
    confirmed: -> @callback(true)
    disposed: -> @callback(false)
