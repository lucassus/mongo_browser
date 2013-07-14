describe "server info page", ->
  beforeEach ->
    browser().navigateTo("/")
    element("a:contains('Server Info')").click()

  it "navigates to the valid url", ->
    expect(browser().location().url()).toBe("/server_info")

  it "displays a valid section title", ->
    title = element("h2").text()
    expect(title).toEqual("server info")

  it "displays details about the server", ->
    list = repeater("table tbody tr")
    expect(list.count()).toBeGreaterThan(0)

    for property in ["version", "gitVersion", "sysInfo", "versionArray", "bits", "debug", "maxBsonObjectSize", "ok"]
      expect(list.column("property")).toContain(property)
