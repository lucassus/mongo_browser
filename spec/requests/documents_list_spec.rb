require "spec_helper"

describe "Documents list", type: :request do
  before do
    visit "/"
    click_link "first_database"
    click_link "first_collection"
  end

  it "displays breadcrumb" do
    within ".breadcrumb" do
      within "li:nth-child(1)" do
        page.should have_content("Databases")
      end

      within "li:nth-child(2)" do
        page.should have_content("db: first_database")
      end

      within "li:nth-child(3)" do
        page.should have_content("collection: first_collection")
      end
    end
  end

  it "displays all documents for the selected collection" do
    page.should have_css("tr.document", count: 2)

    within "table" do
      page.should have_content("This is a sample record")
      page.should have_content("This is the second sample record")
    end
  end
end
