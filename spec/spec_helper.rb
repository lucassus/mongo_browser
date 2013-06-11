require "simplecov"

require "mongo_browser"

require "debugger"
require "rspec"
require "rack/test"

# Requires supporting ruby files with custom matchers and macros, etc,
# from spec/support/ and its subdirectories.
Dir[File.expand_path("spec/support/**/*.rb")].each { |f| require f }

fixtures = Fixtures.instance

RSpec.configure do |config|
  config.before { fixtures.load! }
end
