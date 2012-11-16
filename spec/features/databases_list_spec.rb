require "spec_helper"

describe "Databases list", type: :request do
  before { visit "/" }

  it "hides breadcrumb" do
    expect(page).not_to have_css(".breadcrumb")
  end

  it "displays list with available databases" do
    expect(page).to have_content("Available databases")

    within "table" do
      expect(page).to have_link("first_database")
      expect(page).to have_link("second_database")
    end
  end

  describe "filtering", js: true do
    it "filters databases by name" do
      fill_in_filter("first")

      within "table.databases" do
        expect(page).to have_link("first_database")
        expect(page).to_not have_link("second_database")
      end
    end

    it "displays a notification when nothing has been found" do
      fill_in_filter("third")

      expect(page).to_not have_css("table.databases")
      expect(page).to have_content("Nothing has been found. ")
    end
  end

end
