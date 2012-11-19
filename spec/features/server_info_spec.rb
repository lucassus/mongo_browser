require "spec_helper"

describe "Server info", type: :request do
  before do
    visit "/"

    within(".navbar") { click_link "Server Info" }
  end

  it "has a valid title" do
    within "h2" do
      expect(page).to have_content("server info")
    end
  end

  it "displays information about the server" do
    within "table" do
      %w(version gitVersion sysInfo versionArray bits debug maxBsonObjectSize ok).each do |field|
        expect(page).to have_content(field)
      end
    end
  end
end
