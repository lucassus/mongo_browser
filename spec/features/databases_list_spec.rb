require "spec_helper"

describe "Databases list", type: :request, js: true do
  before { visit "/" }

  it "hides the breadcrumb" do
    expect(page).not_to have_css(".breadcrumb")
  end

  it "has a valid title" do
    within "h2" do
      expect(page).to have_content("localhost databases")
    end
  end

  it "displays list with available databases" do
    within "table" do
      expect(page).to have_link("first_database")
      expect(page).to have_link("second_database")
    end
  end

  describe "filtering" do
    it "filters databases by name" do
      fill_in_filter("first")

      within "table.databases" do
        expect(page).to have_link("first_database")
        expect(page).to_not have_link("second_database")
      end
    end

    it "displays a notification when nothing has been found" do
      fill_in_filter("third")
      should_hide_the_table_and_display_a_notification
    end
  end

  describe "click on delete database button" do
    it "deletes a database" do
      click_delete_button_for("second_database")
      confirm_dialog

      expect(page).to have_flash_message("Database second_database has been deleted.")

      within "table.databases" do
        expect(page).to have_link("first_database")
        expect(page).to_not have_link("second_database")
      end

      click_delete_button_for("first_database")
      confirm_dialog

      expect(page).to have_flash_message("Database first_database has been deleted.")

      should_hide_the_table_and_display_a_notification
    end

    def click_delete_button_for(database_name)
      database_row = find(:xpath, %Q{//table//tr//*[contains(text(), "#{database_name}")]/../..})
      within(database_row) { click_link "Delete" }
    end
  end
end
