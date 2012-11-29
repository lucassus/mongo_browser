require "spec_helper"

describe MongoBrowser::Models::Collection do
  let(:mongo_db_name) { "first_database" }
  let(:mongo_collection_name) { "first_collection" }

  let(:server) { MongoBrowser::Models::Server.current }

  let(:mongo_collection) do
    server.connection[mongo_db_name]
        .collection(mongo_collection_name)
  end

  let(:collection) { described_class.new(mongo_collection) }
  subject { collection }

  it "is initialized with Mongo::Collection" do
    collection.mongo_collection.should == mongo_collection
  end

  its(:db_name) { should == mongo_db_name }
  its(:name) { should == mongo_collection_name }
  its(:size) { should == 2 }

  describe "#stats" do
    it "returns stats for the collection" do
      stats = collection.stats

      expect(stats).not_to be_nil
      expect(stats).to be_an_instance_of(BSON::OrderedHash)
    end
  end

  describe "#drop!" do
    let(:database) { server.database(mongo_db_name) }

    it "drops the collection" do
      collection.drop!
      expect(database.collection_names).not_to include(database.name)
    end
  end
end
