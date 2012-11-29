require "spec_helper"

describe MongoBrowser::Models::Database do
  let(:mongo_db_name) { "first_database" }
  let(:mongo_db) { MongoBrowser::Models::Server.current.connection[mongo_db_name] }

  let(:database) { described_class.new(mongo_db) }
  subject { database }

  its(:id) { should == mongo_db_name }
  its(:name) { should == mongo_db_name }

  its(:size) { should == 218103808 }

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
end
