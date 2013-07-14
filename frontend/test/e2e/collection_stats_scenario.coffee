describe "collection stats page", ->

  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

    element("table.databases tbody tr a:contains('first_database')").click()
    element("table.collections tbody tr a:contains('first_collection')").click()
    element("a.btn:contains('Collection stats')").click()

  it "displays database stats", ->
    expect(repeater("table tbody tr").count()).toBeGreaterThan(0)
