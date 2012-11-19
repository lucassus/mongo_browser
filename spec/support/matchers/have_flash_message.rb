# Usage:
#
# describe "A feature" do
#   specify { page.should have_flash_message("foo") }
# end
RSpec::Matchers.define :have_flash_message do |message|
  match do
    within "div#flash-messages" do
      page.should have_content(message)
    end
  end

  description do
    %Q{have the following flash message: "#{message.inspect}"}
  end
end
