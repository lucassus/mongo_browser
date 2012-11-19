class Mongod
  include Singleton

  MONGODB_DBPATH = "/tmp/mongo_browser/db"

  attr_reader :port
  attr_reader :pid

  def initialize
    @port = find_available_port
  end

  def start!
    return if running?

    FileUtils.mkdir_p(MONGODB_DBPATH)

    @pid = Mongod.start(port)
    wait_until_responsive

    yield port if block_given?
  end

  def shutdown!
    return unless running?

    Process.kill('HUP', pid)
    FileUtils.rm_rf(MONGODB_DBPATH)

    @pid = nil
  end

  # Returns true is mongodb server is ready to use
  def responsive?
    Mongo::Connection.new(MongoBrowser.mongodb_host, port)
    true
  rescue Mongo::ConnectionFailure
    false
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

  # Starts a core MongoDB daemon on the given port.
  def self.start(port)
    command = "mongod --port #{port} --dbpath #{MONGODB_DBPATH} --nojournal"
    log_file = File.open(File.expand_path("log/test_mongod.log"), "w")

    Process.spawn(command, out: log_file)
  end

  # Uses exponential back-off technique for waiting for the mongodb server
  def wait_until_responsive
    wait_time = 0.01
    start_time = Time.now
    timeout = 10

    until responsive?
      raise "Could not start mongd" if Time.now - start_time >= timeout

      sleep wait_time
      wait_time *= 2
    end
  end
end
