#= require vendor/jquery
#= require vendor/bootstrap

$(document).ready ->
  $form = $("form.filter")
  return if $form.size() is 0

  $filterInput = $form.find("input[type='text']")

  clearFilter = ->
    $filterInput.val("")
    filter("")

  filter = (filterVal) ->
    $table = $("table.collections")

    $table.find("tr.collection").each (index, row) ->
      $row = $(row)
      collectionName = $row.find("td:first").text()
      if filterVal is "" or collectionName.match(new RegExp(filterVal))
        $row.show()
      else
        $row.hide()

    $table.show()
    if $table.find("tr.collection:visible").size() == 0
      $table.hide()
      $(".alert").show()
    else
      $table.show()
      $(".alert").hide()

  clearFilter()

  $filterInput.keyup (event) ->
    Escape = 27
    if event.keyCode is Escape
      clearFilter()
    else
      $form.submit()

  $form.find("button.clear").click (event) ->
    event?.preventDefault()
    clearFilter()

  $form.submit (event) ->
    event?.preventDefault()

    filterVal = $filterInput.val()
    filter(filterVal)
