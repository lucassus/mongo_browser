require "singleton"

class Fixtures
  include Singleton

  # Load all fixtures from json file
  def load!
    cleanup!

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

  def load_documents!
    database = connection.db("first_database")
    collection = database.collection("second_collection")
    collection.remove()

    70.times do |n|
      collection.insert(name: "Document #{n}", position: n)
    end
  end

  # Delete all databases
  def cleanup!
    fixture_databases = data.map { |db| db["name"] }

    # Drop collections inside databases
    fixture_databases.each do |db_name|
      collection_names = connection[db_name].collection_names - ["system.indexes"]
      collection_names.each do |collection_name|
        connection[db_name][collection_name].drop
      end
    end
  end

  def data
    JSON.parse(File.open(File.expand_path("spec/support/fixtures/databases.json"), "r").read)
  end

  def connection
    @connection ||= begin
      Mongo::Connection.new(MongoBrowser::DEFAULT_MONGODB_HOST, MongoBrowser.mongodb_port)
    end
  end
end
