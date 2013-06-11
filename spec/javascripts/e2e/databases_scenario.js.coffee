describe "databases list page", ->
  databasesList = null

  shouldShowDatabase = (name) ->
    expect(databasesList.column("database.name")).toContain(name)

  shouldShowAllDatabases = ->
    shouldShowDatabase("first_database")
    shouldShowDatabase("second_database")
    shouldShowDatabase("third_database")

  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

    databasesList = repeater("table.databases tbody tr")

  it "navigates to the valid url", ->
    expect(browser().location().url()).toBe("/")

  it "shows the breadcrumbs", ->
    link = element(".container a.brand")
    expect(link.text()).toEqual("Mongo Browser")
    expect(link.attr("href")).toEqual("/")

  it "displays a valid section title", ->
    title = element("h2").text()
    expect(title).toEqual("localhost databases")

  describe "filtering by database name", ->
    it "displays all databases when the filter is not provided", ->
      input("value").enter("")
      shouldShowAllDatabases()

    it "filters by database name", ->
      input("value").enter("first")
      shouldShowDatabase("first_database")

      input("value").enter("second")
      shouldShowDatabase("second_database")

      input("value").enter("not existing database")
      expect(databasesList.count()).toBe(0)
      expect(element(".alert:visible").text()).toMatch(/Nothing has been found./)

    it "displays all records when the filter is cleared", ->
      element("button:contains('Clear')").click()
      shouldShowAllDatabases()

  describe "delete a database", ->
    deleteDatabase = (name) ->
      element("table.databases tbody tr:contains('#{name}') td:last-child a:contains('Delete')")
        .click()

    beforeEach ->
      deleteDatabase("third_database")
      expect(element("div.modal .modal-body").text())
        .toContain("Deleting third_database. Are you sure?")

    describe "when the dialog was disposed", ->
      beforeEach -> disposeDialog()

      it "does nothig", ->
        shouldShowAllDatabases()

    describe "when the dialog was confirmed", ->
      beforeEach -> confirmDialog()

      it "shows the alert", ->
        expect(repeater("aside#alerts .alert").count()).toBe(1)
        expect(repeater("aside#alerts .alert").column("message.text"))
          .toContain("Database third_database has been deleted.")

      it "deletes a database", ->
        expect(databasesList.column("database.name")).not().toContain("third_database")
