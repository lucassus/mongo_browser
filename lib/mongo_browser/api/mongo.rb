module MongoBrowser::API
  class Mongo < Grape::API
    format :json
    rescue_from :all, backtrace: true

    before do
      method = env["REQUEST_METHOD"]
      path = env["PATH_INFO"]

      logger.info "[api] #{method} #{path}"
    end

    helpers do
      def server
        @server ||= MongoBrowser::Models::Server.current
      end

      def logger
        Grape::API.logger
      end
    end

    resource :databases do
      mount MongoBrowser::API::Databases
    end

    desc "Returns info about the server"
    get "/server_info" do
      server.info
    end

    desc "Returns application version"
    get "/version" do
      {
          version: MongoBrowser::VERSION,
          environment: ENV["RACK_ENV"]
      }
    end

  end
end
