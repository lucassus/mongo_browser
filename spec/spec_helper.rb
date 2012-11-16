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

def find_available_port
  server = TCPServer.new("127.0.0.1", 0)
  server.addr[1]
ensure
  server.close if server
end

MongoBrowser.mongodb_host = "localhost"
MongoBrowser.mongodb_port = find_available_port

require "capybara/webkit"
Capybara.javascript_driver = :webkit

Capybara.ignore_hidden_elements = true
Capybara.app = MongoBrowser::Application

require "support/mongod"
require "support/integration"
require "support/have_flash_message_matcher"

RSpec.configure do |config|
  config.include Integration

  config.before do
    Mongod.start_server
    Mongod.load_fixtures
  end

  config.after do
    if example.metadata[:js] and example.exception
      file_name = example.full_description.downcase.gsub(/\s/, "-")
      page.driver.render("/tmp/#{file_name}.png", full: true)
    end
  end
end

at_exit do
  Mongod.clean_up
end
