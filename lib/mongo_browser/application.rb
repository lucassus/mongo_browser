module MongoBrowser
  class Application < Sinatra::Base
    set :root, File.join(File.dirname(__FILE__), "../../app")
    use MongoBrowser::SprocketsSinatraMiddleware, :root => settings.root, :path => 'assets'

    get '/' do
      @databases = connection.database_info
      erb :index
    end

    get '/server_info' do
      @server_info = connection.server_info
      erb :server_info
    end

    private

    def connection
      @connection ||= Mongo::Connection.new('localhost', 27017)
    end
  end
end
