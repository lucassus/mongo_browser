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
    $table.find("tr.collection").show()

    return if filterVal is ""
    $table.find("tr.collection").each (index, row) ->
      $row = $(row)
      collectionName = $row.find("td:first").text()
      unless collectionName.match(new RegExp(filterVal))
        $row.hide()

  clearFilter()

  $filterInput.keyup (event) ->
    Escape = 27
    if event.keyCode is Escape
      clearFilter()

  $form.find("button.clear").click (event) ->
    event?.preventDefault()
    clearFilter()

  $form.submit (event) ->
    event?.preventDefault()

    filterVal = $filterInput.val()
    filter(filterVal)
