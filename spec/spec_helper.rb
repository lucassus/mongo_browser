$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "mongo_browser"

require "rspec"
require "capybara"
require "capybara/rspec"
require "socket"

require "simplecov"
SimpleCov.start

def find_available_port
  server = TCPServer.new("127.0.0.1", 0)
  server.addr[1]
ensure
  server.close if server
end

MongoBrowser.mongodb_host = "localhost"
MongoBrowser.mongodb_port = find_available_port.to_s
ENV["MONGODB_DBPATH"] = "/tmp/mongo_browser/db"

Capybara.app = MongoBrowser::Application

def start_mongodb_server
  if `lsof -i :#{MongoBrowser.mongodb_port}`.size == 0
    clean_up
    FileUtils.mkdir_p(ENV["MONGODB_DBPATH"])

    `mongod --port #{MongoBrowser.mongodb_port} --dbpath #{ENV["MONGODB_DBPATH"]} --fork --logpath #{ENV["MONGODB_DBPATH"]}/../db.log`
  end
end

def load_fixtures
  connection = Mongo::Connection.new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port)

  # Delete all databases
  connection.database_names do |db_name|
    connection.drop_database(db_name)
  end

  # Load fixtures
  connection.db("first_database").create_collection("first_collection")
  connection.db("second_database").create_collection("first_collection")
end

def clean_up
  out = `ps aux | grep "mongod"`
  out.lines.each do |line|
    if line.include?("mongod") and line.include?("--dbpath #{ENV["MONGODB_DBPATH"]}")
      pid = line.split(/\s/)[1]
      `kill -9 #{pid}`
    end
  end
  FileUtils.rm_rf("#{ENV["MONGODB_DBPATH"]}/..")
end

RSpec.configure do |config|
  config.before do
    start_mongodb_server
    load_fixtures
  end
end

at_exit do
  clean_up
end
