describe "my app", ->
  it "shows the databases page", ->
    browser().navigateTo("/")
    expect(browser().location().url()).toBe("/")

  it "filters databases list", ->
    browser().navigateTo("/")
    expect(repeater("table.databases tbody tr").count()).toBe(5)

    input("value").enter("activecell")
    expect(repeater("table.databases tbody tr").count()).toBe(3)

    input("value").enter("second")
    expect(repeater("table.databases tbody tr").count()).toBe(1)

  it "shows the collections page", ->
    input("value").enter("activecell_development")
    element("table.databases tbody tr td a").click()
    expect(browser().location().url()).toBe("/databases/activecell_development/collections")
