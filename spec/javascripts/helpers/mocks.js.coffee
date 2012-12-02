# Create a mock for dialogsHandler
angular.module("mocks", []).config ($provide) ->
  $provide.factory "dialogsHandler", ->
    confirm: (message, callback) ->
      @callback = callback
    confirmed: -> @callback(true)
    disposed: -> @callback(false)
