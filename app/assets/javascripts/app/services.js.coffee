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

  $provide.factory "defaultDialogsHandler", ["$window", (window) ->
    confirm: (message, callback) ->
      callback(window.confirm(message))
  ]

  $provide.factory "confirmationDialog", ["$log", "bootboxDialogsHandler", ($log, handler) ->
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

  # TODO this will be removed in the future, since all request will be handled by ajax
  $provide.factory "doAction", ->
    (url, method = "get") ->
      form = $("<form />")
          .attr("method", "post")
          .attr("action", url)

      metadataInput = $("<input />")
          .attr("type", "hidden")
          .attr("name", "_method")
          .val(method)

      form.hide().append(metadataInput).appendTo("body");
      form.submit()
