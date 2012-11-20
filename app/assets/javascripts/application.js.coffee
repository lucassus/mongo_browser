FilterCtrl = ($scope) ->
  $scope.value = ""
  $scope.clear = ->
    @value = ""

window.DatabasesCtrl = ($scope) ->
  $scope.$watch 'filterValue', ->
    console.log $scope.value

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
    template: $("#filter-template").text()
    restrict: 'E'
    replace: true
    transclude: true
    controller: FilterCtrl
    scope:
      placeholder: "@placeholder"

    link: (scope, element, attrs) ->
      scope.$watch 'value', ->
        scope.$parent.filterValue = scope.value

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
