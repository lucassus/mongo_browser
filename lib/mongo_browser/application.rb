module MongoBrowser
  class Application < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end

    enable :sessions
    register Sinatra::Flash

    set :root, File.join(File.dirname(__FILE__), "../../app")
    set :method_override, true

    use MongoBrowser::SprocketsSinatraMiddleware, :root => settings.root, :path => "assets"

    get "/" do
      @databases = connection.database_info
      erb :"index"
    end

    get "/databases/:db_name" do
      database = connection.db(params[:db_name])
      @collections = database.collections
      @stats = database.stats

      erb :"databases/show"
    end

    delete "/databases/:db_name" do
      connection.drop_database(params[:db_name])

      flash[:notice] = "Database #{params[:db_name]} has been deleted."
      redirect "/"
    end

    get "/databases/:db_name/collections/:collection_name" do
      database = connection.db(params[:db_name])
      collection = database.collection(params[:collection_name])
      @documents = collection.find()
      @stats = collection.stats

      erb :"collections/show"
    end

    delete "/databases/:db_name/collections/:collection_name" do
      database = connection.db(params[:db_name])
      database.drop_collection(params[:collection_name])

      flash[:notice] = "Collection #{params[:collection_name]} has been deleted."
      redirect "/databases/#{params[:db_name]}"
    end

    get "/server_info" do
      @server_info = connection.server_info
      erb :"server_info"
    end

    private

    def connection
      @connection ||= Mongo::Connection.new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port)
    end
  end
end
