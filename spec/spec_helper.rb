$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rspec"
require "capybara"
require "capybara/rspec"
require "socket"

require "simplecov"
SimpleCov.start

def find_available_port
  server = TCPServer.new('127.0.0.1', 0)
  server.addr[1]
ensure
  server.close if server
end

ENV['MONGODB_PORT'] = find_available_port.to_s

require "mongo_browser"
Capybara.app = MongoBrowser::Application

def check_mongodb_server
  if `lsof -i :#{ENV['MONGODB_PORT']}`.size == 0
    test_dbpath = "/tmp/mongo_browser_test/#{Time.now.to_i}"
    FileUtils.mkdir_p(test_dbpath) unless Dir.exist?(test_dbpath)
    system "mongod --port #{ENV['MONGODB_PORT']} --dbpath #{test_dbpath} --fork --logpath /tmp/mongo_browser_test.log"
  end
end

def load_fixtures
  connection = Mongo::Connection.new('localhost', ENV['MONGODB_PORT'])

  connection.db('first_database').create_collection('first_collection')
  connection.db('second_database').create_collection('first_collection')
end

RSpec.configure do |config|
  config.before do
    check_mongodb_server
    load_fixtures
  end

  config.after do
  end
end
