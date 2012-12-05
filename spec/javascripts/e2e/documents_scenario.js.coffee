describe "documents list page", ->
  beforeEach ->
    browser().navigateTo("/")
    element("table.databases tbody tr a:contains('first_database')").click()
    element("table.collections tbody tr a:contains('first_collection')").click()

  it "shows the documents page", ->
    expect(browser().location().url()).toBe("/databases/first_database/collections/first_collection")

    title = element("h2").text()
    expect(title).toEqual("first_collection documents")

  it "displays a tab with collection stats", ->
    element(".tabbable a:contains('Collection stats')").click()
    expect(repeater("table tbody tr").count()).toBeGreaterThan(0)
