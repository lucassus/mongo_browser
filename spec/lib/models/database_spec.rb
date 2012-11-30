require "spec_helper"

describe MongoBrowser::Models::Database do
  let(:connection) { MongoBrowser::Models::Server.current.connection }
  let(:mongo_db_name) { "first_database" }
  let(:mongo_db) { connection[mongo_db_name] }

  let(:database) { described_class.new(mongo_db) }
  subject { database }

  it "is initialized with Mongo::DB" do
    database.mongo_db.should == mongo_db
  end

  its(:id) { should == mongo_db_name }
  its(:name) { should == mongo_db_name }

  its(:size) { should be_an_instance_of(Fixnum) }

  describe "#collection_names" do
    subject { database.collection_names }

    it { should be_an_instance_of(Array) }
    it { should have(4).items }
    it { should include("system.indexes") }
    it { should include("first_collection") }
    it { should include("second_collection") }
    it { should include("third_collection") }
  end

  describe "#collections" do
    let(:collections) { database.collections }
    subject { collections }

    it { should be_an_instance_of(Array) }
    it { should have(4).items }

    it "contains Collections" do
      collections.each do |db|
        expect(db).to be_an_instance_of(MongoBrowser::Models::Collection)
      end
    end
  end

  describe "#count" do
    it "returns a number of collections" do
      expect(database.count).to eq(database.collections.count)
    end
  end

  describe "#stats" do
    it "returns stats for the database" do
      stats = database.stats

      expect(stats).not_to be_nil
      expect(stats).to be_an_instance_of(BSON::OrderedHash)
    end
  end

  describe "#drop!" do
    it "drops the database" do
      database.drop!
      expect(connection.database_names).not_to include(database.name)
    end
  end

  describe "#collection" do
    it "returns a collection with the given name" do
      collection = database.collection("first_collection")

      expect(collection).to be_an_instance_of(MongoBrowser::Models::Collection)
      expect(collection.name).to eq("first_collection")
    end
  end
end
