class Fixtures
  include Singleton

  # Load all fixtures from json file
  def load!
    cleanup!

    data = JSON.parse(File.open(File.expand_path("spec/fixtures/databases.json"), "r").read)
    data.each do |database_data|
      database = connection.db(database_data["name"])

      (database_data["collections"] || []).each do |collection_data|
        collection = database.create_collection(collection_data["name"])

        (collection_data["documents"] || []).each do |document_data|
          collection.insert(document_data)
        end
      end
    end
  end

  # Delete all databases
  def cleanup!
    connection.database_names.each do |db_name|
      connection.drop_database(db_name)
    end
  end

  def connection
    @connection ||= begin
      Mongo::Connection.new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port)
    end
  end
end
