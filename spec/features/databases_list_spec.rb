require "spec_helper"

describe "Databases list", type: :request, js: true do
  before { visit "/" }

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

      within "table.databases" do
        expect(page).to_not have_link("first_database")
        expect(page).to_not have_link("second_database")
      end
    end

    def click_delete_button_for(database_name)
      database_row = find(:xpath, %Q{//table//tr//*[contains(text(), "#{database_name}")]/../..})
      within(database_row) { click_link "Delete" }
    end
  end
end
