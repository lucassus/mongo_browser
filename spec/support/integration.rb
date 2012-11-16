module Integration

  def fill_in_filter(value)
    page.execute_script <<-JS
        $("form.filter input[type='text']").val("#{value}").keyup();
    JS
  end
end
