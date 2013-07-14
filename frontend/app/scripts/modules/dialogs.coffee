dialogs = angular.module("mb.dialogs", [])

# Simple wrapper for http://bootboxjs.com library
#
# Usage:
# handler.confirm "the message", (confirmed) ->
#   doSomething() if confirmed
dialogs.factory "dialogsHandler", -> bootbox

dialogs.factory "confirmationDialog", [
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
