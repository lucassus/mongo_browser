$(document).ready ->
  # Handles PUT, DELETE, POST methods inside links
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
