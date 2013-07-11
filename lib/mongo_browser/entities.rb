module MongoBrowser::Entities

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
    expose :data, documentation: { type: Hash, desc: "Document" }
  end

  class PagedDocuments < Grape::Entity
    expose :page, documentation: { type: Integer, desc: "Current page." }
    expose :size, documentation: { type: Integer, desc: "Total number of records." }
    expose(:totalPages, documentation: { type: Integer, desc: "Total number of pages" }) do |paged|
      paged.total_pages
    end
    expose :documents, using: Document
  end

end
