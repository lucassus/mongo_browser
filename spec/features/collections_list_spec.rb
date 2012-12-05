require "spec_helper"

describe "Collections list", type: :request, js: true do
  before do
    visit "/"

    within("table.databases") { click_link "first_database" }
  end

  it "displays the breadcrumb" do
    within ".breadcrumbs" do
      within "li:nth-child(1)" do
        expect(page).to have_link("first_database", href: "/databases/first_database/collections")
      end
    end
  end

  describe "click on delete collection button" do
    it "deletes a collection" do
      click_delete_button_for("second_collection")
      confirm_dialog

      expect(page).to have_flash_message("Collection second_collection has been deleted.")

      within "table.collections" do
        expect(page).to have_link("first_collection")
        expect(page).to_not have_link("second_collection")
        expect(page).to have_link("third_collection")
      end

      click_delete_button_for("first_collection")
      confirm_dialog
      expect(page).to have_flash_message("Collection first_collection has been deleted.")

      within "table.collections" do
        expect(page).to_not have_link("first_collection")
        expect(page).to_not have_link("second_collection")
        expect(page).to have_link("third_collection")
      end

      click_delete_button_for("third_collection")
      confirm_dialog
      expect(page).to have_flash_message("Collection third_collection has been deleted.")

      should_hide_the_table_and_display_a_notification
    end

    xit "displays error message when the collection cannot be deleted" do
      click_delete_button_for("system.indexes")
      confirm_dialog

      expect(page).to have_flash_message("Database command 'drop' failed")

      within "table.collections" do
        expect(page).to have_link("system.indexes")
      end
    end

    def click_delete_button_for(collection_name)
      collection_row = find(:xpath, %Q{//table//tr//*[contains(text(), "#{collection_name}")]/../..})
      within(collection_row) { click_link "Delete" }
    end
  end
end
