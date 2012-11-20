module FeatureExampleGroup

  def fill_in_filter(value)
    filter_input = find(%Q{form.filter input[type="text"]})
    filter_input.set(value)
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

  # Take a screenshot and html dump for the page
  def capture_page(file_name = Time.now.to_i.to_s)
    reports_path = File.expand_path("reports/capybara")
    FileUtils.mkdir_p(reports_path)

    file_path = File.join(reports_path, file_name)

    captured_files = []

    html_file = "#{file_path}.html"
    File.open(html_file, "w") { |f| f.write(page.body) }
    captured_files << html_file

    if example.metadata[:js]
      image_file = "#{file_path}.png"
      page.driver.render(image_file, full: true)
      captured_files << image_file
    end

    captured_files
  end
end
