module MongoBrowser
  module Models
    class Collection
      attr_reader :mongo_collection

      def initialize(mongo_collection)
        @mongo_collection = mongo_collection
      end

      def db_name
        mongo_collection.db.name
      end

      def name
        mongo_collection.name
      end

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

        documents = mongo_collection.find
            .skip(pager.offset)
            .limit(pager.per_page)

        return documents, pager
      end

      def drop!
        mongo_collection.drop
      end

      private

      def pager_for(page)
        Pager.new(page, size)
      end
    end
  end
end
