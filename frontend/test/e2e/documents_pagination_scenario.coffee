describe "documents list page", ->
  documentsList = null

  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

    element("table.databases tbody tr a:contains('first_database')").click()
    element("table.collections tbody tr a:contains('second_collection')").click()

    documentsList = repeater("table.documents tbody tr")

  describe "pagination", ->
    it "displays the pager", ->
      expect(documentsList.count()).toEqual(25)
      expect(repeater("div.pagination:first li").count()).toEqual(5)

    # TODO extend this spec
    it "paginate documents", ->
      element("div.pagination:first li a:contains('Next')").click()
      expect(documentsList.count()).toEqual(25)
      expect(browser().location().url())
        .toBe("/databases/first_database/collections/second_collection/documents?page=2")

      element("div.pagination:first li a:contains('Next')").click()
      expect(documentsList.count()).toEqual(20)
      expect(browser().location().url())
        .toBe("/databases/first_database/collections/second_collection/documents?page=3")

      element("div.pagination:first li a:contains('1')").click()
      expect(documentsList.count()).toEqual(25)
      expect(browser().location().url())
        .toBe("/databases/first_database/collections/second_collection/documents")
