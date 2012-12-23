describe "documents list page", ->
  documentsList = null

  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

    element("table.databases tbody tr a:contains('first_database')").click()
    element("table.collections tbody tr a:contains('first_collection')").click()

    documentsList = repeater("table.documents tbody tr")

  it "shows the documents page", ->
    expect(browser().location().url())
        .toBe("/databases/first_database/collections/first_collection/documents")

    title = element("h2").text()
    expect(title).toEqual("first_collection documents")

  it "displays a tab with collection stats", ->
    element(".tabbable a:contains('Collection stats')").click()
    expect(documentsList.count()).toBeGreaterThan(0)

  describe "delete a document", ->
    beforeEach ->
      element("table.documents tbody tr:first td.actions a:contains('Delete')")
        .click()

      expect(element("div.modal .modal-body").text())
        .toContain("Are you sure?")

    describe "when the dialog was disposed", ->
      beforeEach -> disposeDialog()

      it "does nothig", ->
        expect(documentsList.count()).toBe(2)

    describe "when the dialog was confirmed", ->
      beforeEach -> confirmDialog()

      it "shows the alert", ->
        expect(repeater("aside#alerts .alert").count()).toBe(1)
        expect(repeater("aside#alerts .alert").column("message.text"))
          .toMatch(/Document \w+ has been deleted./)

      it "deletes a database", ->
        expect(documentsList.count()).toBe(1)
