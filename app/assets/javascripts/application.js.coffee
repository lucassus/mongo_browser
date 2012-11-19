#= require vendor/jquery
#= require vendor/bootstrap
#= require vendor/bootbox
#= require vendor/angular
#
#= require app/table_filter

$(document).ready ->
  $("form.filter").each (index, form) ->
    $form = $(form)
    filter = new TableFilter($form)

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
