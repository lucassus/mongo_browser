describe "collections list page", ->
  beforeEach ->
    browser().navigateTo("/e2e/load_fixtures")
    browser().navigateTo("/")

    element("table.databases tbody tr a:contains('first_database')").click()

  it "navigates to the valid url", ->
    expect(browser().location().url()).toBe("/databases/first_database/collections")

  it "displays a valid section title", ->
    title = element("h2").text()
    expect(title).toEqual("first_database collections")

  it "displays available collections ordered by name", ->
    expect(repeater("table.collections tbody tr").column("collection.name"))
        .toEqual(["first_collection", "second_collection", "system.indexes", "third_collection"])

  it "filters the collections list", ->
    input("value").enter("")
    expect(repeater("table.collections tbody tr").count()).toBe(4)
    expect(repeater("table.collections tbody tr").column("collection.name"))
        .toEqual(["first_collection", "second_collection", "system.indexes", "third_collection"])

    input("value").enter("first")
    expect(repeater("table.collections tbody tr").count()).toBe(1)
    expect(repeater("table.collections tbody tr").column("collection.name"))
        .toEqual(["first_collection"])

    input("value").enter("second")
    expect(repeater("table.collections tbody tr").count()).toBe(1)
    expect(repeater("table.collections tbody tr").column("collection.name"))
        .toEqual(["second_collection"])

    input("value").enter("collection")
    expect(repeater("table.collections tbody tr").count()).toBe(3)
    expect(repeater("table.collections tbody tr").column("collection.name"))
        .toEqual(["first_collection", "second_collection", "third_collection"])

    input("value").enter("not existing")
    expect(repeater("table.collections tbody tr").count()).toBe(0)
    expect(element(".filter.alert:visible").text()).toMatch(/Nothing has been found./)

    element("button:contains('Clear')").click()
    expect(repeater("table.collections tbody tr").count()).toBe(4)

  it "displays a tab with database stats", ->
    element(".tabbable a:contains('Database stats')").click()
    expect(repeater("table tbody tr").count()).toBeGreaterThan(0)
