describe "database stats page", ->

  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

    element("table.databases tbody tr a:contains('first_database')").click()
    element("a.btn:contains('Database stats')").click()

  it "displays database stats", ->
    expect(repeater("table tbody tr").count()).toBeGreaterThan(0)
