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
    # All routes without `/api` prefix
    get /^(?!\/api).+/ do
      erb :"index"
    end

    # Databases list
    get "/api/databases.json" do
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

    # Delete a database
    delete "/api/databases/:db_name.json" do |db_name|
      database = server.database(db_name)
      database.drop!

      respond_to do |format|
        format.json { true }
      end
    end

    # Collections list
    get "/api/databases/:db_name/collections.json" do |db_name|
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

    # Delete a collection
    delete "/api/databases/:db_name/collections/:collection_name.json" do |db_name, collection_name|
      success = begin
        collection = server.database(db_name).collection(collection_name)
        collection.drop!
        true
      rescue Mongo::OperationFailure => e
        false
      end

      respond_to do |format|
        format.json { success }
      end
    end

    # Documents list
    get "/api/databases/:db_name/collections/:collection_name/documents.json" do |db_name, collection_name|
      collection = server.database(db_name).collection(collection_name)
      documents, pagination = collection.documents_with_pagination(params[:page])

      documents.map! do |doc|
        {
            id: doc.id.to_s,
            data: doc.data.to_json
        }
      end

      respond_to do |format|
        format.json { documents.to_json }
      end
    end

    # Delete a document
    delete "/api/databases/:db_name/collections/:collection_name/documents/:id.json" do |db_name, collection_name, id|
      collection = server.database(db_name).collection(collection_name)
      document = collection.find(id)
      collection.remove!(document)

      respond_to do |format|
        format.json { true }
      end
    end

    get "/api/server_info.json" do
      server_info = server.info

      respond_to do |format|
        format.json { server_info.to_json }
      end
    end

    private

    def server
      @server ||= Server.current
    end
  end
end
