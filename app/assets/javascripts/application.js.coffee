#= require vendor/jquery
#= require vendor/bootstrap
#
#= require app/table_filter

$(document).ready ->
  $("form.filter").each (index, form) ->
    $form = $(form)
    filter = new TableFilter($form)
