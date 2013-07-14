dsl = angular.scenario.dsl

# Access to iframe's jQuery, see: https://gist.github.com/1700488
dsl "appElement", ->
  (selector, fn) ->
    @addFutureAction "element " + selector, ($window, $document, done) ->
      fn.call this, $window.angular.element(selector)
      done()

dsl "confirmDialog", ->
  ->
    @addFutureAction "confirm dialog", ($window, $document, done) ->
      $window.angular.element("div.bootbox a:contains('OK')").click()
      done()

dsl "disposeDialog", ->
  ->
    @addFutureAction "confirm dialog", ($window, $document, done) ->
      $window.angular.element("div.bootbox a:contains('Cancel')").click()
      done()
