describe "collections list page", ->
  collectionsList = null

  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

    element("table.databases tbody tr a:contains('first_database')").click()
    collectionsList = repeater("table.collections tbody tr")

  it "navigates to the valid url", ->
    expect(browser().location().url()).toBe("/databases/first_database/collections")

  it "shows the breadcrumbs", ->
    link = element(".container a.brand")
    expect(link.text()).toEqual("Mongo Browser")
    expect(link.attr("href")).toEqual("/")

    dbLink = element(".container .breadcrumbs li:nth-child(1) a")
    expect(dbLink.text()).toEqual("first_database")
    expect(dbLink.attr("href")).toEqual("/databases/first_database/collections")

  it "displays a valid section title", ->
    title = element("h2").text()
    expect(title).toEqual("first_database collections")

  it "displays available collections ordered by name", ->
    expect(collectionsList.column("collection.name"))
        .toEqual(["first_collection", "second_collection", "system.indexes", "third_collection"])

  it "filters the collections list", ->
    input("value").enter("")
    expect(collectionsList.count()).toBe(4)
    expect(collectionsList.column("collection.name"))
        .toEqual(["first_collection", "second_collection", "system.indexes", "third_collection"])

    input("value").enter("first")
    expect(collectionsList.count()).toBe(1)
    expect(collectionsList.column("collection.name"))
        .toEqual(["first_collection"])

    input("value").enter("second")
    expect(collectionsList.count()).toBe(1)
    expect(collectionsList.column("collection.name"))
        .toEqual(["second_collection"])

    input("value").enter("collection")
    expect(collectionsList.count()).toBe(3)
    expect(collectionsList.column("collection.name"))
        .toEqual(["first_collection", "second_collection", "third_collection"])

    input("value").enter("not existing")
    expect(collectionsList.count()).toBe(0)
    expect(element(".filter.alert:visible").text()).toMatch(/Nothing has been found./)

    element("button:contains('Clear')").click()
    expect(collectionsList.count()).toBe(4)

  it "displays a tab with database stats", ->
    element(".tabbable a:contains('Database stats')").click()
    expect(repeater("table tbody tr").count()).toBeGreaterThan(0)

  describe "delete a collection", ->
    deleteCollection = (name) ->
      element("table.collections tbody tr:contains('#{name}') td.actions a:contains('Delete')")
        .click()

    beforeEach ->
      deleteCollection("third_collection")
      expect(element("div.modal .modal-body").text())
        .toContain("Deleting third_collection. Are you sure?")

    describe "when the dialog was disposed", ->
      beforeEach -> disposeDialog()

      it "does nothig", ->
        expect(collectionsList.count()).toBe(4)
        expect(collectionsList.column("collection.name"))
          .toEqual(["first_collection", "second_collection", "system.indexes", "third_collection"])

    describe "when the dialog was confirmed", ->
      beforeEach -> confirmDialog()

      it "shows the alert", ->
        expect(repeater("aside#alerts .alert").count()).toBe(1)
        expect(repeater("aside#alerts .alert").column("message.text"))
          .toContain("Collection third_collection has been deleted.")

      it "deletes a database", ->
        expect(collectionsList.count()).toBe(3)
        expect(collectionsList.column("collection.name"))
          .toEqual(["first_collection", "second_collection", "system.indexes"])
