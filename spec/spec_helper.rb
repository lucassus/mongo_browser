$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "simplecov"
SimpleCov.start do
  add_group "Application", "lib"
end

require "mongo_browser"

require "debugger"
require "rspec"
require "capybara"
require "capybara/rspec"
require "socket"

require "capybara/webkit"
Capybara.javascript_driver = :webkit

Capybara.ignore_hidden_elements = true
Capybara.app = MongoBrowser::Application

# Requires supporting ruby files with custom matchers and macros, etc,
# from spec/support/ and its subdirectories.
Dir[File.expand_path("spec/support/**/*.rb")].each { |f| require f }

test_server = Mongod.instance
fixtures = Fixtures.instance

RSpec.configure do |config|
  config.include Integration

  config.before do
    # TODO do it only for request specs

    test_server.run! do |port|
      MongoBrowser.mongodb_host = "localhost"
      MongoBrowser.mongodb_port = port
    end

    fixtures.load!
  end

  config.after do
    # Take a screenshot when the scenario has failed
    if example.metadata[:js] and example.exception
      file_name = example.full_description.downcase.gsub(/\s/, "-")
      page.driver.render("/tmp/#{file_name}.png", full: true)
    end
  end
end

at_exit do
  test_server.shutdown!
end
