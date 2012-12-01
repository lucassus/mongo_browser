require "spec_helper"

describe "Collections list", type: :request, js: true do
  before do
    visit "/"

    within("table.databases") { click_link "first_database" }
  end

  it "displays the breadcrumb" do
    within ".breadcrumbs" do
      within "li:nth-child(1)" do
        expect(page).to have_link("first_database", href: "#")
      end
    end
  end

  it "has a valid title" do
    within "h2" do
      expect(page).to have_content("first_database collections")
    end
  end

  it "displays all available collections for the selected database" do
    within "table" do
      expect(page).to have_link("first_collection")
      expect(page).to have_link("second_collection")
      expect(page).to have_link("third_collection")
    end
  end

  it "displays information about the database" do
    click_link "Stats"

    within "table" do
      %w(db collection objects avgObjSize dataSize storageSize numExtents indexes indexSize nsSizeMB ok).each do |field|
        expect(page).to have_content(field)
      end
    end
  end

  describe "filtering" do
    it "filters collections by name" do
      fill_in_filter("second")

      within "table.collections" do
        expect(page).to have_link("second_collection")
        expect(page).to_not have_link("first_collection")
        expect(page).to_not have_link("third_collection")
      end
    end

    it "displays a notification when nothing has been found" do
      fill_in_filter("fifth")

      expect(page).to_not have_css("table.collections")
      expect(page).to have_content("Nothing has been found.")
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

    it "displays error message when the collection cannot be deleted" do
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
