#= require vendor/jquery
#= require vendor/bootstrap
#
#= require app/table_filter

$(document).ready ->
  $("form.filter").each (index, form) ->
    $form = $(form)
    filter = new TableFilter($form)

  $(".btn.delete-database").click (event) ->
    return unless confirm("Are you sure?")

    $btn = $(event.target)
    $form = $btn.parent().find("form")
    $form.submit()
