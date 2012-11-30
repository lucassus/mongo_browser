module MongoBrowser
  module Models
    class Document
      attr_reader :mongo_document

      def initialize(mongo_document)
        @mongo_document = mongo_document
      end

      def id
        mongo_document["_id"]
      end

      alias :data :mongo_document
    end
  end
end
