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

  $provide.factory "pager", ->
    (options = {}) ->
      page: options.page || 1
      totalPages: options.totalPages
      innerWindow: if options.innerWindow? then options.innerWindow else 4
      outerWindow: if options.outerWindow? then options.outerWindow else 1

      windowedPageNumbers: ->
        windowFrom = @page - @innerWindow
        windowTo = @page + @innerWindow

        # adjust lower or upper limit if other is out of bounds
        if windowTo > @totalPages
          windowFrom -= windowTo - @totalPages
          windowTo = @totalPages

        if windowFrom < 1
          windowFrom = 1
          windowTo += windowTo - windowFrom
          windowTo = @totalPages if windowTo > @totalPages

        middle = [windowFrom..windowTo]

        # left window
        middleFirst = middle[0]
        if @outerWindow + 3 < middleFirst # there's a gap
          left = [1..(@outerWindow + 1)]
          left.push(null)
        else # runs into visible pages
          left = [1...middleFirst]

        # right window
        middleLast = middle[middle.length - 1]
        if @totalPages - @outerWindow - 2 > middleLast # again, gap
          right = [(@totalPages - @outerWindow)..@totalPages]
          right.unshift(null)
        else # runs into visible pages
          if middleLast < @totalPages
            right = [(middleLast + 1)..@totalPages]
          else
            right = []

        left.concat(middle).concat(right)
