require "simplecov"

require "mongo_browser"

require "debugger"
require "rspec"

# Requires supporting ruby files with custom matchers and macros, etc,
# from spec/support/ and its subdirectories.
Dir[File.expand_path("spec/support/**/*.rb")].each { |f| require f }

test_server = Mongod.instance
fixtures = Fixtures.instance

RSpec.configure do |config|
  config.include FeatureExampleGroup, type: :request

  # Run test mongod instance and load database fixtures
  config.before do
    test_server.start! do |port|
      MongoBrowser.mongodb_host = "127.0.0.1"
      MongoBrowser.mongodb_port = port
    end

    fixtures.load!
  end
end

at_exit do
  test_server.shutdown!
end
