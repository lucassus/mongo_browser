pager = angular.module("mb.pager", [])

pager.factory "pager", ->
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

pager.controller "pager", ($scope, pager) ->
  paginate = ->
    prepare = pager(page: $scope.page, totalPages: $scope.totalPages)
    $scope.windowedPageNumbers = prepare.windowedPageNumbers()

  $scope.$watch "page", (page) ->
    $scope.$emit "PageChanged", page
    paginate()

  $scope.$watch "totalPages", -> paginate()

  $scope.setPage = (page) ->
    return if page < 1 or page > $scope.totalPages
    $scope.page = page

  $scope.next = ->
    $scope.page += 1 if $scope.hasNext()

  $scope.hasNext = ->
    $scope.page < $scope.totalPages

  $scope.prev = ->
    $scope.page -= 1 if $scope.hasPrev()

  $scope.hasPrev = ->
    $scope.page > 1

  $scope.display = -> $scope.totalPages > 1

pager.directive "pager", ->
  templateUrl: "/ng/templates/pager.html"
  restrict: "E"
  replace: true

  scope:
    page: "=page"
    totalPages: "=totalPages"

  controller: "pager"
