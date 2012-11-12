$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rspec"
require "capybara"
require "capybara/rspec"

require "simplecov"
SimpleCov.start

require "mongo_browser"
Capybara.app = MongoBrowser::Application
