module MongoBrowser
  module Models
    class Collection
      attr_reader :mongo_collection

      def initialize(mongo_collection)
        @mongo_collection = mongo_collection
      end

      # Return database name for the current collection.
      def db_name
        mongo_collection.db.name
      end

      # Return collection name.
      def name
        mongo_collection.name
      end

      # Return total number of documents.
      def size
        mongo_collection.size
      end

      # Return stats on the collection.
      #
      # @return [Hash]
      def stats
        mongo_collection.stats
      end

      def documents_with_pagination(page_number = 1)
        pager = pager_for(page_number)

        paged_documents = mongo_collection.find
            .skip(pager.offset)
            .limit(pager.per_page)

        return paged_documents.map { |doc| Document.new(doc) }, pager
      end

      def drop!
        mongo_collection.drop
      end

      # Finds a document with the given id.
      #
      # @return MongoBrowser::Models::Document
      def find(id)
        condition = { _id: BSON::ObjectId(id.to_s) }
        mongo_document = mongo_collection.find(condition).first
        Document.new(mongo_document) if mongo_document
      end

      # Removes the given document from the collection.
      def remove!(document)
        mongo_collection.remove(_id: document.id)
      end

      private

      def pager_for(page)
        Pager.new(page, size)
      end
    end
  end
end
