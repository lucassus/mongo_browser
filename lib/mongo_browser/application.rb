require "sinatra"
require "sinatra/reloader"
require "sinatra/respond_with"

require "sprockets"
require "sass"
require "coffee_script"

require "mongo_browser/middleware/sprockets_sinatra"

module MongoBrowser
  class Application < Sinatra::Base
    include Models

    enable :sessions

    set :root, File.join(File.dirname(__FILE__), "../../app")
    set :public_folder, File.join(settings.root, "../public")

    set :method_override, true

    register Sinatra::RespondWith

    use Middleware::SprocketsSinatra, :root => File.join(settings.root, "..")

    if settings.development? or settings.test?
      require "mongo_browser/application/development"
      register Development
    end

    # Loads given template from assets/templates directory
    get "/ng/templates/:name.html" do |template_name|
      send_file File.join(settings.root, "assets/templates/#{template_name}.html")
    end

    # Welcome page
    # All routes without `/api` prefix
    get /^(?!\/api).+/ do
      File.read(File.join(settings.public_folder, "index.html"))
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
    delete "/api/databases.json" do
      database = server.database(params[:id])
      database.drop!

      respond_to do |format|
        format.json { true }
      end
    end

    # Database stats
    get "/api/databases/:db_name/stats.json" do |db_name|
      database = server.database(db_name)

      respond_to do |format|
        format.json { database.stats.to_json }
      end
    end

    # Collections list
    get "/api/databases/:db_name/collections.json" do |db_name|
      database = server.database(db_name)
      collections = database.collections.map do |collection|
        {
            dbName: collection.db_name,
            name:   collection.name,
            size:   collection.size
        }
      end

      respond_to do |format|
        format.json { collections.to_json }
      end
    end

    # Delete a collection
    delete "/api/databases/:db_name/collections.json" do |db_name|
      success = begin
        collection = server.database(db_name).collection(params[:id])
        collection.drop!
        true
      rescue Mongo::OperationFailure => e
        false
      end

      respond_to do |format|
        format.json { success }
      end
    end

    # Collection stats
    get "/api/databases/:db_name/collections/:collection_name/stats.json" do |db_name, collection_name|
      collection = server.database(db_name).collection(collection_name)

      respond_to do |format|
        format.json { collection.stats.to_json }
      end
    end

    # Documents list
    get "/api/databases/:db_name/collections/:collection_name/documents.json" do |db_name, collection_name|
      collection = server.database(db_name).collection(collection_name)
      documents, pagination = collection.documents_with_pagination(params[:page])

      documents.map! do |doc|
        {
            id: doc.id.to_s,
            data: doc.data
        }
      end

      respond_to do |format|
        format.json do
          {
              documents:  documents,
              size:       pagination.size,
              page:       pagination.current_page,
              totalPages: pagination.total_pages
          }.to_json
        end
      end
    end

    # Delete a document
    delete "/api/databases/:db_name/collections/:collection_name/documents.json" do |db_name, collection_name|
      collection = server.database(db_name).collection(collection_name)
      document = collection.find(params[:id])
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

    get "/api/version.json" do
      respond_to do |format|
        format.json do
          { version: MongoBrowser::VERSION }.to_json
        end
      end
    end

    private

    def server
      @server ||= Server.current
    end
  end
end
