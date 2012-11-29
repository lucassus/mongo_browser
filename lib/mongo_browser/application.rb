require "sinatra"
require "sinatra/reloader"
require "sinatra/flash"
require "will_paginate-bootstrap"

require "sprockets"
require "sass"
require "coffee_script"

require "mongo_browser/middleware/sprockets_sinatra"

module MongoBrowser
  class Application < Sinatra::Base
    include Models

    configure :development do
      register Sinatra::Reloader
    end

    enable :sessions
    register Sinatra::Flash

    set :root, File.join(File.dirname(__FILE__), "../../app")
    set :method_override, true

    use Middleware::SprocketsSinatra, :root => File.join(settings.root, "..")
    register WillPaginate::Sinatra

    # Databases list
    get "/" do
      @databases = server.databases.map do |db|
        {
            id:    db.id,
            name:  db.name,
            size:  db.size.to_f / (1024 * 1024),
            count: db.count
        }
      end

      erb :"databases/index"
    end

    # Collections list
    get "/databases/:db_name" do |db_name|
      database = server.database(db_name)

      @collections = database.collections
      @stats = database.stats

      erb :"collections/index"
    end

    # Delete a database
    delete "/databases/:db_name" do |db_name|
      database = server.database(db_name)
      database.drop!

      flash[:info] = "Database #{db_name} has been deleted."
      redirect "/"
    end

    # Documents list
    get "/databases/:db_name/collections/:collection_name" do |db_name, collection_name|
      database = connection.db(db_name)
      collection = database.collection(collection_name)

      @stats = collection.stats
      @documents, @pagination = paginate_documents_for(collection, params[:page])

      erb :"documents/index"
    end

    # Delete a collection
    delete "/databases/:db_name/collections/:collection_name" do |db_name, collection_name|
      begin
        database = connection.db(db_name)
        database.drop_collection(collection_name)

        flash[:info] = "Collection #{collection_name} has been deleted."
      rescue Mongo::OperationFailure => e
        flash[:error] = e.message
      end

      redirect "/databases/#{db_name}"
    end

    # Delete a document
    delete "/databases/:db_name/collections/:collection_name/:id" do |db_name, collection_name, id|
      database = connection.db(db_name)
      collection = database.collection(collection_name)

      id = BSON::ObjectId(id)
      collection.remove(_id: id)

      flash[:info] = "Document #{id} has been deleted."
      redirect "/databases/#{db_name}/collections/#{collection_name}"
    end

    # Server info
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

    # TODO remove this method
    def connection
      server.connection
    end

    def server
      @server ||= Server.current
    end
  end
end
