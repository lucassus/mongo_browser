describe "documents list page", ->
  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

    element("table.databases tbody tr a:contains('first_database')").click()
    element("table.collections tbody tr a:contains('first_collection')").click()
    element("table.documents tbody tr:first td span.id a").click()

  it "shows the document page", ->
    expect(browser().location().url()).toMatch(/\/databases\/first_database\/collections\/first_collection\/documents\/.+/)
