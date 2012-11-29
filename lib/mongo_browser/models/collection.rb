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
    end
  end
end
