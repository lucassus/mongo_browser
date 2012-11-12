require "spec_helper"

describe "Collections list", type: :request do
  before do
    visit "/"
    click_link "first_database"
  end

  it "displays breadcrumb" do
    within ".breadcrumb" do
      within "li:nth-child(1)" do
        page.should have_content("Databases")
      end

      within "li:nth-child(2)" do
        page.should have_content("db: first_database")
      end
    end
  end

  it "displays all available collections for the selected database" do
    within "table" do
      page.should have_content("first_collection")
      page.should have_content("second_collection")
      page.should have_content("third_collection")
    end
  end
end
