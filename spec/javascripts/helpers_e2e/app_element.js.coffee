# Access to iframe's jQuery, see: https://gist.github.com/1700488
angular.scenario.dsl "appElement", ->
  (selector, fn) ->
    @addFutureAction "element " + selector, ($window, $document, done) ->
      fn.call this, $window.angular.element(selector)
      done()
