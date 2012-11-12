require "spec_helper"

describe "Databases list", type: :request do
  before { visit "/" }

  it "hides breadcrumb" do
    page.should_not have_css(".breadcrumb")
  end

  it "displays list with available databases" do
    page.should have_content("Available databases")

    within "table" do
      page.should have_content("first_database")
      page.should have_content("second_database")
    end
  end

end
