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
    end
  end
end
