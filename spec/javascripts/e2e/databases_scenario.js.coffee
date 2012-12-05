describe "my app", ->
  it "shows the databases page", ->
    browser().navigateTo("/")
    expect(browser().location().url()).toBe("/")

  it "filters databases list", ->
    browser().navigateTo("/")
    expect(repeater("table.databases tbody tr").count()).toBe(3)

    input("value").enter("database")
    expect(repeater("table.databases tbody tr").count()).toBe(2)

    input("value").enter("other")
    expect(repeater("table.databases tbody tr").count()).toBe(1)

  it "shows the collections page", ->
    input("value").enter("first_database")
    element("table.databases tbody tr td a").click()
    expect(browser().location().url()).toBe("/databases/first_database/collections")
