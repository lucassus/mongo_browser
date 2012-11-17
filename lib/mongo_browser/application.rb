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
    register WillPaginate::Sinatra

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

      flash[:info] = "Database #{params[:db_name]} has been deleted."
      redirect "/"
    end

    get "/databases/:db_name/collections/:collection_name" do
      database = connection.db(params[:db_name])
      collection = database.collection(params[:collection_name])

      @stats = collection.stats
      @documents, @pagination = paginate_documents_for(collection, params[:page])

      erb :"collections/show"
    end

    delete "/databases/:db_name/collections/:collection_name" do
      begin
        database = connection.db(params[:db_name])
        database.drop_collection(params[:collection_name])

        flash[:info] = "Collection #{params[:collection_name]} has been deleted."
      rescue Mongo::OperationFailure => e
        flash[:error] = e.message
      end

      redirect "/databases/#{params[:db_name]}"
    end

    get "/server_info" do
      @server_info = connection.server_info
      erb :"server_info"
    end

    private

    def paginate_documents_for(collection, page = 1)
      per_page = 25

      count = collection.count
      total_pages = (count.to_f / per_page).ceil

      page = if page.to_i <= 0 then 1
             else
               [page.to_i, total_pages].min
             end

      offset = (page - 1) * per_page
      documents = collection.find.skip(offset).limit(per_page)
      pagination = OpenStruct.new \
        total_pages: total_pages,
        current_page: page

      return documents, pagination
    end

    def connection
      @connection ||= Mongo::Connection.new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port)
    end
  end
end
