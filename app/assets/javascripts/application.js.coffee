#= require vendor/jquery
#= require vendor/bootstrap
#= require vendor/bootbox
#= require vendor/angular

window.FilterCtrl = ($scope) ->
  $scope.clear = ->
    @filter = null

angular.module('MongoBrowser', [])
  # Handles ESC key
  .directive 'onEsc', ->
    (scope, element, attrs) ->
      element.bind 'keyup', (event) ->
        EscapeCode = 27
        scope.$apply(attrs.onEsc) if event.keyCode is EscapeCode

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
