$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

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
    test_server.run! do |port|
      MongoBrowser.mongodb_host = "localhost"
      MongoBrowser.mongodb_port = port
    end

    fixtures.load!
  end

  # Take a screenshot when the scenario has failed
  config.after type: :request do
    if example.exception
      reports_path = File.expand_path("reports/capybara")
      FileUtils.mkdir_p(reports_path)

      file_name = example.full_description.downcase.gsub(/\s/, "-")
      file_path = File.join(reports_path, file_name)

      File.open("#{file_path}.html", "w") { |f| f.write(page.body) }
      if example.metadata[:js]
        page.driver.render("#{file_path}.png", full: true)
      end
    end
  end
end

at_exit do
  test_server.shutdown!
end
