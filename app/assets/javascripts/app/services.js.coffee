angular.module "mb.services", [], ($provide) ->

  $provide.factory "dialogsHandler", -> bootbox

  $provide.factory "confirmationDialog", [
    "$log", "dialogsHandler", ($log, handler) ->

      # Options:
      #  message  - a message to display inside the dialog
      #             default: "Are you sure?"
      #  onOk     - a handler for Ok button
      #  onCancel - a handler for Cancel button
      (options = {}) ->
        options.message ||= "Are you sure?"
        $log.info("Displaying confirmation dialog:", options.message)

        handler.confirm options.message, (confirmed) ->
          if confirmed
            $log.info("Confirmation dialog was confirmed")
            (options.onOk || ->)()
          else
            $log.info("Confirmation dialog was disposed")
            (options.onCancel || ->)()
  ]

  $provide.factory "alerts", [
    "$log", "$timeout", ($log, $timeout) ->
      lastId: 0
      messages: []

      # Returns a next id for the new message
      nextId: ->
        @lastId += 1

      push: (type, text) ->
        id = @nextId()
        $log.info("Alert [#{id}, #{type}]", text)

        @messages.push(id: id, type: type, text: text)
        @delayedDispose(id)

        id

      # Helper methods for various alerts types
      info: (text) -> @push("info", text)
      error: (text) -> @push("error", text)

      # Removes a message with the given id
      dispose: (id) ->
        at = @messages.map((message) -> message.id).indexOf(id)
        @messages.splice(at, 1)

      # Dispose the message after the given time in milliseconds
      delayedDispose: (id, timeout = 3000) ->
        disposeTheAlert = =>
          $log.info("Disposing alert", id, "after", timeout, "milliseconds")
          @dispose(id)
        $timeout(disposeTheAlert, timeout)
  ]
