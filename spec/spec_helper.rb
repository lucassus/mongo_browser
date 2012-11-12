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
    clean_up

    test_dbpath = "/tmp/mongo_browser/db"
    FileUtils.mkdir_p(test_dbpath) unless Dir.exist?(test_dbpath)
    `mongod --port #{ENV['MONGODB_PORT']} --dbpath #{test_dbpath} --fork --logpath /tmp/mongo_browser/db.log`
  end
end

def load_fixtures
  connection = Mongo::Connection.new('localhost', ENV['MONGODB_PORT'])

  # Delete all databases
  connection.database_names do |db_name|
    connection.drop_database(db_name)
  end

  # Load fixtures
  connection.db('first_database').create_collection('first_collection')
  connection.db('second_database').create_collection('first_collection')
end

def clean_up
  out = `ps aux | grep "mongod --port #{ENV['MONGODB_PORT']}"`
  out.lines.each do |line|
    unless line.match /ps aux/ or line.match /grep/
      pid = line.split(/\s/)[2]
      `kill -9 #{pid}`
    end
  end
  FileUtils.rm_rf("/tmp/mongo_browser")
end

RSpec.configure do |config|
  config.before do
    check_mongodb_server
    load_fixtures
  end
end

at_exit do
  clean_up
end
