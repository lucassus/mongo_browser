module MongoBrowser
  module Models
    class Document
      attr_reader :db_name, :collection_name
      attr_reader :mongo_document

      def initialize(db_name, collection_name, mongo_document)
        @db_name = db_name
        @collection_name = collection_name

        @mongo_document = mongo_document
      end

      def id
        mongo_document["_id"]
      end

      alias :data :mongo_document
    end
  end
end
