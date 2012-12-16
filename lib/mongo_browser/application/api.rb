class MongoBrowser::Application
  module Api
    def self.registered(app)

      # Databases list
      app.get "/api/databases.json" do
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
      app.delete "/api/databases.json" do
        database = server.database(params[:id])
        database.drop!

        respond_to do |format|
          format.json { true }
        end
      end

      # Database stats
      app.get "/api/databases/:db_name/stats.json" do |db_name|
        database = server.database(db_name)

        respond_to do |format|
          format.json { database.stats.to_json }
        end
      end

      # Collections list
      app.get "/api/databases/:db_name/collections.json" do |db_name|
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
      app.delete "/api/databases/:db_name/collections.json" do |db_name|
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
      app.get "/api/databases/:db_name/collections/:collection_name/stats.json" do |db_name, collection_name|
        collection = server.database(db_name).collection(collection_name)

        respond_to do |format|
          format.json { collection.stats.to_json }
        end
      end

      # Documents list
      app.get "/api/databases/:db_name/collections/:collection_name/documents.json" do |db_name, collection_name|
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
      app.delete "/api/databases/:db_name/collections/:collection_name/documents.json" do |db_name, collection_name|
        collection = server.database(db_name).collection(collection_name)
        document = collection.find(params[:id])
        collection.remove!(document)

        respond_to do |format|
          format.json { true }
        end
      end

      app.get "/api/server_info.json" do
        server_info = server.info

        respond_to do |format|
          format.json { server_info.to_json }
        end
      end

      app.get "/api/version.json" do
        respond_to do |format|
          format.json do
            { version: MongoBrowser::VERSION }.to_json
          end
        end
      end

    end
  end
end
