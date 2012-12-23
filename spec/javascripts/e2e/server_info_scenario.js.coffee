describe "server info page", ->
  beforeEach ->
    browser().navigateTo("/")
    element("a:contains('Server Info')").click()

  it "displays a valid section title", ->
    title = element("h2").text()
    expect(title).toEqual("server info")

  it "displays details about the server", ->
    expect(browser().location().url()).toBe("/server_info")

    title = element("h2").text()
    expect(title).toEqual("server info")

    expect(repeater("table tbody tr").count()).toBeGreaterThan(0)
