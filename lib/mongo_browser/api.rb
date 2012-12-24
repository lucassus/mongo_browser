require "grape"

module MongoBrowser
  class DatabasesApi < Grape::API
    format :json

    helpers do
      def server
        @server ||= MongoBrowser::Models::Server.current
      end
    end

    resource :databases do
      desc "Get a list of all databases for the current server"
      get do
        present server.databases, with: Api::Entities::Database
      end

      params do
        requires :db_name, type: String, desc: "Database name."
      end
      segment "/:db_name" do

        desc "Deletes a database with the given name"
        delete do
          database = server.database(params[:db_name])
          database.drop!
          { success: true }
        end

        desc "Get stats for the given database"
        get "/stats" do
          database = server.database(params[:db_name])
          database.stats
        end

        resources :collections do
          desc "Get a list of all collections for the given database"
          get do
            database = server.database(params[:db_name])
            collections = database.collections
            present collections, with: Api::Entities::Collection
          end

          params do
            requires :collection_name, type: String, desc: "Collection name."
          end
          segment "/:collection_name" do

            desc "Get stats for a collection with the given name"
            get "/stats" do
              collection = server.database(params[:db_name]).collection(params[:collection_name])
              collection.stats
            end

            desc "Drop a collection with the given name"
            delete do
              collection = server.database(params[:db_name]).collection(params[:collection_name])
              collection.drop!
              { success: true }
            end

            resources :documents do
              params do
                optional :page, type: Integer, desc: "Page number."
              end
              get do
                collection = server.database(params[:db_name]).collection(params[:collection_name])
                documents = collection.documents_with_pagination(params[:page])
                present documents, with: Api::Entities::PagedDocuments
              end

              params do
                requires :id, type: String, desc: "Document id."
              end
              segment "/:id" do
                delete do
                  collection = server.database(params[:db_name]).collection(params[:collection_name])
                  document = collection.find(params[:id])
                  collection.remove!(document)
                  { success: true }
                end
              end
            end
          end
        end
      end
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

  class Api < Grape::API
    module Entities
      class Database < Grape::Entity
        expose :name, documentation: { type: String, desc: "Database name." }
        expose :size, documentation: { type: Integer, desc: "Database size in bytes." }
        expose :count, documentation: { type: Integer, desc: "Number of collections." }
      end

      # TODO add docs
      class Collection < Grape::Entity
        expose(:dbName) { |collection| collection.db_name }
        expose :name
        expose :size
      end

      # TODO add docs
      class Document < Grape::Entity
        expose(:id) { |document| document.id.to_s }
        expose :data
      end

      # TODO add docs
      class PagedDocuments < Grape::Entity
        expose :page
        expose :size
        expose(:totalPages) { |paged| paged.total_pages }
        expose :documents, using: Document
      end
    end

    mount DatabasesApi
  end
end
