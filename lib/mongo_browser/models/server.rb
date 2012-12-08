module MongoBrowser
  module Models
    class Server

      class << self
        def current
          new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port)
        end
      end

      attr_reader :host
      attr_reader :port

      def initialize(host, port)
        @host, @port = host, port
      end

      # Return database for the give name.
      #
      # @return MongoBrowser::Models::Database
      def database(name)
        Database.new(connection.db(name))
      end

      # Return a list of available database names.
      #
      # @return [String]
      def database_names
        connection.database_names.reject { |name| name == "admin" }
      end

      # Return a list of available databases.
      #
      # @return [MongoBrowser::Models::Database]
      def databases
        database_names.map { |name| database(name) }
      end

      # Get the build information for the current connection.
      #
      # @return [Hash]
      def info
        connection.server_info
      end

      def connection
        @connection ||= Mongo::Connection.new(host, port)
      end
    end
  end
end
