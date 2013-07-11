module MongoBrowser::Api
  class Documents < Grape::API

    desc "Get a list of paginated documents"
    params do
      optional :page, type: Integer, desc: "Page number"
    end
    get do
      collection = server.database(params[:db_name]).collection(params[:collection_name])
      documents = collection.documents_with_pagination(params[:page])
      present documents, with: MongoBrowser::Entities::PagedDocuments
    end

    params do
      requires :id, type: String, desc: "Document id"
    end
    segment "/:id" do
      desc "Get a document"
      get do
        collection = server.database(params[:db_name]).collection(params[:collection_name])
        document = collection.find(params[:id])

        error!("Document not found", 404) if document.nil?
        present document, with: MongoBrowser::Entities::Document
      end

      desc "Deletes a document with the given id"
      delete do
        collection = server.database(params[:db_name]).collection(params[:collection_name])
        document = collection.find(params[:id])
        collection.remove!(document)
        { success: true }
      end
    end

  end
end