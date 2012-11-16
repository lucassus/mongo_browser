require "spec_helper"

describe "Documents list", type: :request do
  before do
    visit "/"
    click_link "first_database"
    click_link "first_collection"
  end

  it "displays the breadcrumb" do
    within ".breadcrumb" do
      within "li:nth-child(1)" do
        expect(page).to have_link("Databases")
      end

      within "li:nth-child(2)" do
        expect(page).to have_link("db: first_database")
      end

      within "li:nth-child(3)" do
        expect(page).to have_content("collection: first_collection")
      end
    end
  end

  it "displays all documents for the selected collection" do
    expect(page).to have_css("tr.document", count: 2)

    within "table" do
      expect(page).to have_content("This is a sample record")
      expect(page).to have_content("This is the second sample record")
    end
  end
end
