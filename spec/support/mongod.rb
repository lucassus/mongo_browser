class Mongod
  include Singleton

  MONGODB_DBPATH = "/tmp/mongo_browser/db"

  attr_reader :port
  attr_reader :pid

  def initialize
    @port = find_available_port
  end

  def run!
    return if running?

    FileUtils.mkdir_p(MONGODB_DBPATH)

    log_file = File.open(File.expand_path("log/test_mongod.log"), "w+")
    @pid = spawn("mongod --port #{port} --dbpath #{MONGODB_DBPATH} --nojournal", out: log_file)

    # TODO wait for the connection (waiting for connections on port xxxx)
    sleep 2

    yield port if block_given?
  end

  def shutdown!
    return unless running?

    Process.kill('HUP', pid)
    FileUtils.rm_rf("#{MONGODB_DBPATH}/..")

    @pid = nil
  end

  def running?
    not pid.nil?
  end

  def load_fixtures!
    # Delete all databases
    connection.database_names.each do |db_name|
      connection.drop_database(db_name)
    end

    # Load fixtures
    data = JSON.parse(File.open(File.expand_path("spec/fixtures/databases.json"), "r").read)
    data.each do |database_data|
      database = connection.db(database_data["name"])

      (database_data["collections"] || []).each do |collection_data|
        collection = database.create_collection(collection_data["name"])

        (collection_data["documents"] || []).each do |document_data|
          collection.insert(document_data)
        end
      end
    end
  end

  def connection
    @connection ||= Mongo::Connection.new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port)
  end

  private

  def find_available_port
    server = TCPServer.new("127.0.0.1", 0)
    server.addr[1]
  ensure
    server.close if server
  end
end
