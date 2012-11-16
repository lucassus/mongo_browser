require "spec_helper"

describe "Server info", type: :request do
  before do
    visit "/"

    within ".navbar" do
      click_link "Server Info"
    end
  end

  it "displays information about the server" do
    within "table" do
      expect(page).to have_content("version")
      expect(page).to have_content("gitVersion")
      expect(page).to have_content("sysInfo")
      expect(page).to have_content("versionArray")
      expect(page).to have_content("bits")
      expect(page).to have_content("debug")
      expect(page).to have_content("maxBsonObjectSize")
      expect(page).to have_content("ok")
    end
  end
end
