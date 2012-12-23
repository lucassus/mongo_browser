require "spec_helper"

describe "Collections list", type: :request, js: true do
  before do
    visit "/"

    within("table.databases") { click_link "first_database" }
  end

  xit "displays the breadcrumb" do
    within ".breadcrumbs" do
      within "li:nth-child(1)" do
        expect(page).to have_link("first_database", href: "/databases/first_database/collections")
      end
    end
  end
end
