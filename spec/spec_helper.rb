require "simplecov"

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
  config.include FeatureExampleGroup, type: :request

  # Run test mongod instance and load database fixtures
  config.before type: :request do
    test_server.start! do |port|
      MongoBrowser.mongodb_host = "127.0.0.1"
      MongoBrowser.mongodb_port = port
    end

    fixtures.load!
  end

  # Take a screenshot and html dump when the scenario has failed
  config.after type: :request do
    if example.exception
      file_name = example.full_description.downcase.gsub(/\s/, "-")
      capture_page(file_name)
    end
  end
end

at_exit do
  test_server.shutdown!
end
