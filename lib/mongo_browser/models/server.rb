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

    end
  end
end
