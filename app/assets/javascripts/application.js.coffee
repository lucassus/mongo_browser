#= require vendor/jquery
#= require vendor/bootstrap
#= require vendor/bootbox
#
#= require app/table_filter

$(document).ready ->
  $("form.filter").each (index, form) ->
    $form = $(form)
    filter = new TableFilter($form)

  $(".btn.delete-database").click (event) ->
    bootbox.confirm 'Are you sure?', (confirmed) =>
      return unless confirmed

      $btn = $(event.target)
      $form = $btn.parents('td').find("form")
      $form.submit()
