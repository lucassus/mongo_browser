module MongoBrowser
  class Application < Sinatra::Base
    set :root, File.join(File.dirname(__FILE__), "../../app")
    use MongoBrowser::SprocketsSinatraMiddleware, :root => settings.root, :path => 'assets'

    get '/' do
      connection = Mongo::Connection.new('localhost', 27017)
      @databases = connection.database_info
      @server_info = connection.server_info

      erb :index
    end
  end
end
