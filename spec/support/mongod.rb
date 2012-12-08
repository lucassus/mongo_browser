require "singleton"

# Utility for run and manage test mongod instance.
class Mongod
  include Singleton

  MONGODB_DBPATH = "/tmp/mongo_browser/db"
  # port for test mongod instance
  MONGODB_PORT = 27018

  attr_reader :pid

  # Start test mongod instance
  # * it cleans up the test server directory
  # * starts a daemon
  # * and wait until its fully responsive
  def start!
    return if running?

    FileUtils.mkdir_p(MONGODB_DBPATH)

    @pid = Mongod.start
    wait_until_responsive

    yield MONGODB_PORT if block_given?
  end

  # Kills test mongod instance
  def shutdown!
    return unless running?

    Process.kill('HUP', pid)

    @pid = nil
  end

  # Returns true is mongodb server is ready to use
  def responsive?
    Mongo::Connection.new(MongoBrowser::DEFAULT_HOST, MONGODB_PORT)
    true
  rescue Mongo::ConnectionFailure
    false
  end

  def running?
    not pid.nil?
  end

  private

  class << self

    # Check whether port for test mongod is available,
    def test_port_available?
      begin
        server = TCPServer.new(MongoBrowser::DEFAULT_HOST, MONGODB_PORT)
        true
      rescue
        false
      end
    ensure
      server.close if server
    end

    # Starts a core MongoDB test daemon.
    def start
      raise "port #{MONGODB_PORT} is not available" unless test_port_available?

      command = "mongod --config #{File.expand_path("spec/support/mongodb.conf")}"
      log_file = File.open(File.expand_path("log/test_mongod.log"), "w")

      Process.spawn(command, out: log_file)
    end
  end

  # Uses exponential back-off technique for waiting for the mongodb server
  def wait_until_responsive
    wait_time = 0.01
    start_time = Time.now
    timeout = 10

    until responsive?
      raise "Could not start mongod after #{timeout} seconds" if Time.now - start_time >= timeout

      sleep wait_time
      wait_time *= 2
    end
  end
end
