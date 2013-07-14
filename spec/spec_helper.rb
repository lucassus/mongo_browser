require "simplecov"

require "mongo_browser"

require "debugger"
require "rspec"
require "rack/test"

require "coveralls"
Coveralls.wear!

# Requires supporting ruby files with custom matchers and macros, etc,
# from spec/support/ and its subdirectories.
Dir[File.expand_path("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.before do
    fixtures = Fixtures.instance
    fixtures.load!
  end
end
