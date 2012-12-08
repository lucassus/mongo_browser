describe "databases list page", ->
  it "shows the databases page", ->
    browser().navigateTo("/")

  it "navigates to the valid url", ->
    expect(browser().location().url()).toBe("/")

  it "displays a valid section title", ->
    title = element("h2").text()
    expect(title).toEqual("localhost databases")

  it "displays available databases ordered by name", ->
    expect(repeater("table.databases tbody tr").column("database.name"))
        .toEqual(["first_database", "second_database"])

  it "filters the databases list", ->
    input("value").enter("")
    expect(repeater("table.databases tbody tr").count()).toBe(2)
    expect(repeater("table.databases tbody tr").column("database.name"))
        .toEqual(["first_database", "second_database"])

    input("value").enter("first")
    expect(repeater("table.databases tbody tr").count()).toBe(1)
    expect(repeater("table.databases tbody tr").column("database.name"))
        .toEqual(["first_database"])

    input("value").enter("second")
    expect(repeater("table.databases tbody tr").count()).toBe(1)
    expect(repeater("table.databases tbody tr").column("database.name"))
        .toEqual(["second_database"])

    input("value").enter("not existing")
    expect(repeater("table.databases tbody tr").count()).toBe(0)
    expect(element(".filter.alert:visible").text()).toMatch(/Nothing has been found./)

    element("button:contains('Clear')").click()
    expect(repeater("table.databases tbody tr").count()).toBe(2)
    expect(repeater("table.databases tbody tr").column("database.name"))
        .toEqual(["first_database", "second_database"])
