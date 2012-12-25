class MongoBrowser::Api
  module Entities
    class Database < Grape::Entity
      expose :name, documentation: { type: String, desc: "Database name." }
      expose :size, documentation: { type: Integer, desc: "Database size in bytes." }
      expose :count, documentation: { type: Integer, desc: "Number of collections." }
    end

    class Collection < Grape::Entity
      expose(:dbName, documentation: { type: String, desc: "Database name." }) do |collection|
        collection.db_name
      end
      expose :name, documentation: { type: String, desc: "Collection name." }
      expose :size, documentation: { type: Integer, desc: "Number of documents." }
    end

    class Document < Grape::Entity
      expose(:id, documentation: { type: String, desc: "Document id." }) do |document|
        document.id.to_s
      end
      expose :data, document: { type: Hash, desc: "Document" }
    end

    # TODO add docs
    class PagedDocuments < Grape::Entity
      expose :page
      expose :size
      expose(:totalPages) { |paged| paged.total_pages }
      expose :documents, using: Document
    end
  end
end
