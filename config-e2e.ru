require "mongo_browser"

require File.expand_path("spec/support/mongod")
require File.expand_path("spec/support/fixtures")

test_server = Mongod.instance
fixtures = Fixtures.instance

test_server.start! do |port|
  MongoBrowser.mongodb_host = "127.0.0.1"
  MongoBrowser.mongodb_port = port
end

fixtures.load!

run MongoBrowser::Application
