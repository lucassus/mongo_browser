module MongoBrowser::API
  class Collections < Grape::API

    desc "Get a list of all collections for the given database"
    get do
      database = server.database(params[:db_name])
      collections = database.collections
      present collections, with: MongoBrowser::Entities::Collection
    end

    params do
      requires :collection_name, type: String, desc: "Collection name"
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
        mount MongoBrowser::API::Documents
      end
    end

  end
end
