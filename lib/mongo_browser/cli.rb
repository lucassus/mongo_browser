require "mongo_browser"

require "thor"
require "thin"

module MongoBrowser
  RACK_CONFIG = File.expand_path("config.ru")

  class CLI < Thor
    desc :start, "Starts the application"
    option :port, aliases: :p, default: "5678",
        desc: "Specify application port"
    option :environment, aliases: :e, default: "production",
        desc: "Specify application environment"
    option :"mongodb-port", default: MongoBrowser::DEFAULT_MONGODB_PORT,
        desc: "Specify mongodb port"
    option :"mongodb-host", default: MongoBrowser::DEFAULT_MONGODB_HOST,
        desc: "Specify mongodb host"

    def start
      setup_mongodb_connection!(options)
      run_thin(options)
    end

    private

    def setup_mongodb_connection!(options)
      port = options[:"mongodb-port"].to_i
      MongoBrowser.mongodb_port = port
      puts "MongoDB port: #{port}"

      host = options[:"mongodb-host"]
      MongoBrowser.mongodb_host = host
      puts "MongoDB host: #{host}"
    end

    def run_thin(options)
      argv = ["start"]
      argv << ["-R", RACK_CONFIG]
      argv << ["-p", options[:port]]
      argv << ["-e", options[:environment]]

      puts "Application environment: #{options[:environment]}"
      puts "Application url: http://localhost:#{options[:port]}"
      Thin::Runner.new(argv.flatten).run!
    end
  end
end
