require "spec_helper"

describe "Collections list", type: :request do
  before do
    visit "/"
    click_link "first_database"
  end

  it "displays breadcrumb" do
    within ".breadcrumb" do
      within "li:nth-child(1)" do
        expect(page).to have_link("Databases")
      end

      within "li:nth-child(2)" do
        expect(page).to have_link("db: first_database")
      end
    end
  end

  it "displays all available collections for the selected database" do
    within "table" do
      expect(page).to have_link("first_collection")
      expect(page).to have_link("second_collection")
      expect(page).to have_link("third_collection")
    end
  end

  describe "filtering", js: true do
    it "filters collections by name" do
      fill_in_filter("second")

      within "table.collections" do
        expect(page).to have_link("second_collection")
        expect(page).to_not have_link("first_collection")
        expect(page).to_not have_link("third_collection")
      end
    end

    it "displays notification when nothing has been found" do
      fill_in_filter("fifth")

      expect(page).to_not have_css("table.collections")
      expect(page).to have_content("Nothing has been found. ")
    end
  end
end
