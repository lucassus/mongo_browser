FilterCtrl = ($scope) ->
  $scope.value = ""
  $scope.clear = ->
    @value = ""

angular.module('MongoBrowser', [])
  # Handles ESC key
  .directive 'onEsc', ->
    (scope, element, attrs) ->
      element.bind 'keyup', (event) ->
        EscapeCode = 27
        return unless event.keyCode is EscapeCode
        scope.$apply(attrs.onEsc)

  # Filter for databases and collections
  .directive 'filter', ->
    restrict: 'E'
    replace: true
    transclude: true
    scope:
      placeholder: "@placeholder"
    controller: FilterCtrl
    template: $("#filter-template").text()
    link: (scope, element, attrs) ->
      scope.$watch 'value', ->
        $clearButton = element.find("button")

        if scope.value is ""
          $clearButton.addClass("disabled")
        else
          $clearButton.removeClass("disabled")

$(document).ready ->

  $("a[data-method]").click (event) ->
    event.preventDefault()

    $link = $(event.target)

    createAndSubmitForm = ->
      action = $link.attr("href")
      $form = $("<form />").attr("method", "post").attr("action", action)

      method = $link.data("method")
      $metadataInput = $("<input />").attr("type", "hidden").attr("name", "_method").val(method)

      $form.hide().append($metadataInput).appendTo("body");
      $form.submit()

    confirmationMessage = $link.data("confirm")
    if confirmationMessage?
      bootbox.confirm confirmationMessage, (confirmed) =>
        createAndSubmitForm() if confirmed
    else
      createAndSubmitForm()
