window.TableFilter = class TableFilter
  constructor: (@$form) ->
    @$table = $("table.#{$form.data('filter-for')}")

    @$form.find("input[type='text']").keyup (event) =>
      Escape = 27
      if event.keyCode is Escape
        @clearFilter()
      else
        @$form.submit()

    @$form.find("button.clear").click (event) =>
      event?.preventDefault()
      @clearFilter()

    @$form.submit (event) =>
      event?.preventDefault()

      filterVal = @getFilterInput()
      @filter(filterVal)

    @filter()

  filter: ->
    filterVal = @getFilterInput()
    @$table.find("tbody tr").each (index, row) =>
      $row = $(row)
      name = $row.find("td:first").text()
      if filterVal is "" or name.match(new RegExp(filterVal))
        $row.show()
      else
        $row.hide()

    @$table.show()
    if @$table.find("tbody tr:visible").size() == 0
      @$table.hide()
      $(".filter.alert").show()
    else
      @$table.show()
      $(".filter.alert").hide()

  clearFilter: ->
    @setFilterInput('')
    @filter()

  setFilterInput: (value) ->
    @$form.find("input[type='text']").val(value)

  getFilterInput: ->
    @$form.find("input[type='text']").val()
