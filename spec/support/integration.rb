module Integration

  def fill_in_filter(value)
    page.execute_script <<-JS
        $("form.filter input[type='text']").val("#{value}").keyup();
    JS
  end

  def confirm_dialog(message = 'Are you sure?')
    begin
      wait_until { page.has_css?("div.bootbox.modal") }
    rescue Capybara::TimeoutError
      raise "Expected confirmation modal to be visible."
    end

    within "div.bootbox.modal" do
      page.should have_content(message)
      click_link "OK"
    end
  end

  def should_hide_the_table_and_display_a_notification
    expect(page).to_not have_css("table.databases")
    expect(page).to have_content("Nothing has been found.")
  end
end
