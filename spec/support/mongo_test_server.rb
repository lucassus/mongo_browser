module MongoTestServer
  extend self
  
  MONGODB_DBPATH = "/tmp/mongo_browser/db"

  def ensure_test_server_is_running
    if `lsof -i :#{MongoBrowser.mongodb_port}`.size == 0
      clean_up

      FileUtils.mkdir_p(MONGODB_DBPATH)
      `mongod --port #{MongoBrowser.mongodb_port} --dbpath #{MONGODB_DBPATH} --fork --logpath #{MONGODB_DBPATH}/../db.log`
    end
  end

  def load_fixtures
    connection = Mongo::Connection.new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port)

    # Delete all databases
    connection.database_names.each do |db_name|
      connection.drop_database(db_name)
    end

    # Load fixtures
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

  def clean_up
    out = `ps aux | grep "mongod"`
    out.lines.each do |line|
      if line.include?("mongod") and line.include?("--dbpath #{MONGODB_DBPATH}")
        pid = line.split[1]
        `kill -9 #{pid}`
      end
    end
    FileUtils.rm_rf("#{MONGODB_DBPATH}/..")
  end
end
