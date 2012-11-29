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

      # TODO write specs
      # TODO refactor it
      def documents_with_pagination(page = 1)
        per_page = 25

        total_pages = (size.to_f / per_page).ceil

        page = if page.to_i <= 0 then 1
               else
                 [page.to_i, total_pages].min
               end

        offset = (page - 1) * per_page
        documents = mongo_collection.find.skip(offset).limit(per_page)
        pagination = OpenStruct.new \
            total_pages: total_pages,
            current_page: page

        return documents, pagination
      end
    end
  end
end
