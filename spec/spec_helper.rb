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

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.ignore_hidden_elements = true
Capybara.app = MongoBrowser::Application

require "support/mongod"
require "support/integration"

RSpec.configure do |config|
  config.include Integration

  config.before do
    Mongod.start_server
    Mongod.load_fixtures
  end
end

at_exit do
  Mongod.clean_up
end
