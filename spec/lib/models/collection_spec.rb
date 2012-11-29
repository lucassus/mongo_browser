require "spec_helper"

describe MongoBrowser::Models::Collection do
  let(:mongo_db_name) { "first_database" }
  let(:mongo_collection_name) { "first_collection" }

  let(:mongo_collection) do
    MongoBrowser::Models::Server.current
        .connection[mongo_db_name]
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
end
