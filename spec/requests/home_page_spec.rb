require "spec_helper"

describe "Home page", type: :request do
  before { visit "/" }

  specify do
    page.should have_content("Available databases")

    within "table" do
      page.should have_content("first_database")
      page.should have_content("second_database")
    end
  end

  specify do
    click_link "first_database"

    within ".breadcrumb" do
      within "li:nth-child(1)" do
        page.should have_content("Databases")
      end

      within "li:nth-child(2)" do
        page.should have_content("db: first_database")
      end
    end
    
    within "table" do
      page.should have_content("first_collection")
    end
  end

  specify do
    click_link "first_database"
    click_link "first_collection"

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

    page.should have_css("tr.document", count: 2)

    within "table" do
      page.should have_content("This is a sample record")
      page.should have_content("This is the second sample record")
    end
  end

end
