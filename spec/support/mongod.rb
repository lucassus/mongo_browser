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

  private

  def find_available_port
    server = TCPServer.new("127.0.0.1", 0)
    server.addr[1]
  ensure
    server.close if server
  end
end
