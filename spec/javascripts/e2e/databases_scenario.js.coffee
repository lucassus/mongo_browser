describe "databases list page", ->
  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

  it "navigates to the valid url", ->
    expect(browser().location().url()).toBe("/")

  it "displays a valid section title", ->
    title = element("h2").text()
    expect(title).toEqual("localhost databases")

  it "displays available databases ordered by name", ->
    expect(repeater("table.databases tbody tr").column("database.name"))
        .toEqual(["first_database", "second_database", "third_database"])

  describe "filtering by database name", ->
    it "displays all databases when the filter is not provided", ->
      input("value").enter("")
      expect(repeater("table.databases tbody tr").count()).toBe(3)
      expect(repeater("table.databases tbody tr").column("database.name"))
          .toEqual(["first_database", "second_database", "third_database"])

    it "filters by database name", ->
      input("value").enter("first")
      expect(repeater("table.databases tbody tr").count()).toBe(1)
      expect(repeater("table.databases tbody tr").column("database.name"))
          .toEqual(["first_database"])

      input("value").enter("second")
      expect(repeater("table.databases tbody tr").count()).toBe(1)
      expect(repeater("table.databases tbody tr").column("database.name"))
          .toEqual(["second_database"])

      input("value").enter("not existing")
      expect(repeater("table.databases tbody tr").count()).toBe(0)
      expect(element(".filter.alert:visible").text()).toMatch(/Nothing has been found./)

    it "displays all records when the filter is cleared", ->
      element("button:contains('Clear')").click()
      expect(repeater("table.databases tbody tr").count()).toBe(3)
      expect(repeater("table.databases tbody tr").column("database.name"))
          .toEqual(["first_database", "second_database", "third_database"])

  describe "delete a database", ->
    beforeEach ->
      element("table.databases tbody tr:contains('third_database') td.actions a:contains('Delete')").click()
      expect(element("div.modal .modal-body").text()).toContain("Deleting third_database. Are you sure?")

    describe "when the dialog was disposed", ->
      beforeEach ->
        appElement "div.modal .modal-footer a:contains('Cancel')", ($element) ->
          $element.click()

      it "does nothig", ->
          expect(repeater("table.databases tbody tr").count()).toBe(3)
          expect(repeater("table.databases tbody tr").column("database.name"))
              .toEqual(["first_database", "second_database", "third_database"])

    # TODO figure out how to test it
    xdescribe "when the dialog was confirmed", ->
      beforeEach ->
        appElement "div.bootbox a:contains('OK')", ($element) ->
          $element.click()

      it "shows the alert", ->
        expect(repeater("aside#alerts .alert").count()).toBe(1)
        expect(repeater("aside#alerts .alert").column("message.text"))
            .toContain("Database third_database has been deleted.")

      it "deletes a database", ->
        expect(repeater("table.databases tbody tr").count()).toBe(2)
        expect(repeater("table.databases tbody tr").column("database.name"))
            .toEqual(["first_database", "second_database"])
