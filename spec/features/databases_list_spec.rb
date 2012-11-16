require "spec_helper"

describe "Databases list", type: :request do
  before { visit "/" }

  it "hides the breadcrumb" do
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
      should_hide_the_table_and_display_a_notification
    end
  end

  describe "click on delete database button", js: true do
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

    def confirm_dialog(message = 'Are you sure?')
      begin
        wait_until { page.has_css?("div.bootbox.modal") }
      rescue Capybara::TimeoutError
        flunk "Expected confirmation modal to be visible."
      end

      within "div.bootbox.modal" do
        page.should have_content(message)
        click_link "OK"
      end
    end
  end

  def should_hide_the_table_and_display_a_notification
    expect(page).to_not have_css("table.databases")
    expect(page).to have_content("Nothing has been found.")
  end
end
