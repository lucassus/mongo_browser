describe "documents list page", ->
  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

    element("table.databases tbody tr a:contains('first_database')").click()
    element("table.collections tbody tr a:contains('first_collection')").click()
    element("table.documents tbody tr:first td span.id a").click()

  it "shows the document page", ->
    expect(browser().location().url()).toMatch(/\/databases\/first_database\/collections\/first_collection\/documents\/.+/)

  describe "when the document has not been found", ->
    beforeEach ->
      notExistingDocumentId = "50f486f1dac5d50540000003"
      browser().navigateTo("/databases/first_database/collections/first_collection/documents/#{notExistingDocumentId}")

    it "redirects to the documents list page", ->
      expect(browser().location().url()).toEqual("/databases/first_database/collections/first_collection/documents")

    it "sets the flash error message", ->
      expect(repeater("aside#alerts .alert").count()).toBe(1)
      expect(repeater("aside#alerts .alert").column("message.text"))
        .toEqual(["Document not found"])
