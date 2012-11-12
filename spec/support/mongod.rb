module Mongod
  extend self
  
  MONGODB_DBPATH = "/tmp/mongo_browser/db"

  def start_server
    if `lsof -i :#{MongoBrowser.mongodb_port}`.size == 0
      clean_up

      FileUtils.mkdir_p(MONGODB_DBPATH)
      `mongod --port #{MongoBrowser.mongodb_port} --dbpath #{MONGODB_DBPATH} --fork --logpath #{MONGODB_DBPATH}/../db.log`
    end
  end

  def load_fixtures
    connection = Mongo::Connection.new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port)

    # Delete all databases
    connection.database_names do |db_name|
      connection.drop_database(db_name)
    end

    # Load fixtures
    connection.db("first_database").create_collection("first_collection")
    connection.db("second_database").create_collection("first_collection")
  end

  def clean_up
    out = `ps aux | grep "mongod"`
    out.lines.each do |line|
      if line.include?("mongod") and line.include?("--dbpath #{MONGODB_DBPATH}")
        pid = line.split(/\s/)[1]
        `kill -9 #{pid}`
      end
    end
    FileUtils.rm_rf("#{MONGODB_DBPATH}/..")
  end
end
