module MongoBrowser::Api
  class Databases < Grape::API

    desc "Get a list of all databases for the current server"
    get do
      present server.databases, with: MongoBrowser::Entities::Database
    end

    params do
      requires :db_name, type: String, desc: "Database name"
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
        mount MongoBrowser::Api::Collections
      end
    end

  end
end
