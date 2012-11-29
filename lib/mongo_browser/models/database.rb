module MongoBrowser
  module Models
    class Database
      attr_reader :mongo_db

      def initialize(mongo_db)
        @mongo_db = mongo_db
      end

      def name
        mongo_db.name
      end
      alias :id :name

      def count
        collections.count
      end

      def size
        info["sizeOnDisk"].to_i
      end

      def collection_names
        mongo_db.collection_names
      end

      def collections
        # TODO initialize collections
        collection_names.map do |collection_name|
          Collection.new
        end
      end

      private

      def info
        @info ||= mongo_db.connection["admin"].command(listDatabases: true)["databases"].find do |db|
          db["name"] == name
        end
      end
    end
  end
end
