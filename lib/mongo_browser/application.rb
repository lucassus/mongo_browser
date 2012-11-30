require "sinatra"
require "sinatra/reloader"
require "sinatra/flash"
require "sinatra/respond_with"
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
    register Sinatra::RespondWith

    # Loads given template from assets/templates directory
    get "/ng/templates/:name.html" do |template_name|
      send_file File.join(settings.root, "assets/templates/#{template_name}.html")
    end

    # Welcome page
    get "/" do
      erb :"databases/index"
    end

    # Databases list
    get "/databases.json" do
      databases = server.databases.map do |db|
        {
            id:    db.id,
            name:  db.name,
            size:  db.size,
            count: db.count
        }
      end

      respond_to do |format|
        format.json { databases.to_json }
      end
    end

    # Collections list
    get "/databases/:db_name.json" do |db_name|
      database = server.database(db_name)
      collections = database.collections.map do |collection|
        {
            db_name: collection.db_name,
            name: collection.name,
            size: collection.size
        }
      end

      respond_to do |format|
        format.json { collections.to_json }
      end
    end

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
      collection = server.database(db_name).collection(collection_name)

      @stats = collection.stats
      @documents, @pagination = collection.documents_with_pagination(params[:page])

      erb :"documents/index"
    end

    # Delete a collection
    delete "/databases/:db_name/collections/:collection_name" do |db_name, collection_name|
      begin
        collection = server.database(db_name).collection(collection_name)
        collection.drop!

        flash[:info] = "Collection #{collection_name} has been deleted."
      rescue Mongo::OperationFailure => e
        flash[:error] = e.message
      end

      redirect "/databases/#{db_name}"
    end

    # Delete a document
    delete "/databases/:db_name/collections/:collection_name/:id" do |db_name, collection_name, id|
      collection = server.database(db_name).collection(collection_name)
      document = collection.find(id)
      collection.remove!(document)

      flash[:info] = "Document #{id} has been deleted."
      redirect "/databases/#{db_name}/collections/#{collection_name}"
    end

    # Server info
    get "/server_info" do
      @server_info = server.info
      erb :"server_info"
    end

    private

    def server
      @server ||= Server.current
    end
  end
end
