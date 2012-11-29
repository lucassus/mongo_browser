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

      def size
        info["sizeOnDisk"].to_i
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
