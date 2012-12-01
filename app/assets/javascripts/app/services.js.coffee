angular.module "mb.services", [], ($provide) ->

  $provide.factory "tableFilterFactory", ($filter) ->
    (scope, collectionName) ->
      collectionCopy: angular.copy(scope[collectionName])

      filter: (value) ->
        scope[collectionName] = $filter("filter")(@collectionCopy, value)

      matchesCount: ->
        scope[collectionName].length

      noMatches: ->
        @matchesCount() is 0

  $provide.factory "bootboxDialogsHandler", -> bootbox

  $provide.factory "defaultDialogsHandler", [
    "$window", (window) ->

      confirm: (message, callback) ->
        callback(window.confirm(message))
  ]

  $provide.factory "confirmationDialog", [
    "$log", "bootboxDialogsHandler", ($log, handler) ->

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
    "$log", ($log) ->
      messages: {}

      push: (type, message) ->
        $log.info("Alert [#{type}]", message)

        @messages[type] ||= []
        @messages[type].push(message)

      info: (message) -> @push("info", message)
      error: (message) -> @push("error", message)

      # Remove a message with the given type at the given index
      dispose: (type, at) ->
        @messages[type].splice(at, 1)
  ]
