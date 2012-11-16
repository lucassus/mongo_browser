#= require vendor/jquery
#= require vendor/bootstrap
#= require vendor/bootbox
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
      $form = $("<form method='post' action='#{action}'></form>")

      method = $link.data("method")
      metadata_input = "<input name='_method' value='#{method}' type='hidden' />"

      $form.hide().append(metadata_input).appendTo("body");
      $form.submit()

    confirmationMessage = $link.data("confirm")
    if confirmationMessage?
      bootbox.confirm confirmationMessage, (confirmed) =>
        createAndSubmitForm() if confirmed
    else
      createAndSubmitForm()
