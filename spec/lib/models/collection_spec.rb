require "spec_helper"

describe MongoBrowser::Models::Collection do
  let(:db_name) { "first_database" }
  let(:collection_name) { "first_collection" }

  let(:server) { MongoBrowser::Models::Server.current }

  let(:mongo_collection) do
    server.connection[db_name]
        .collection(collection_name)
  end

  let(:collection) { described_class.new(mongo_collection) }
  subject { collection }

  it "is initialized with Mongo::Collection" do
    collection.mongo_collection.should == mongo_collection
  end

  its(:db_name) { should == db_name }
  its(:name) { should == collection_name }
  its(:size) { should == 2 }

  describe "#stats" do
    let(:stats) { collection.stats }

    it "returns stats for the collection" do
      expect(stats).not_to be_nil
      expect(stats).to be_an_instance_of(BSON::OrderedHash)
    end
  end

  describe "#drop!" do
    let(:database) { server.database(db_name) }

    it "drops the collection" do
      collection.drop!
      expect(database.collection_names).not_to include(database.name)
    end
  end

  describe "#documents_with_pagination" do
    subject { collection.documents_with_pagination }

    it { should be_an_instance_of(OpenStruct) }
    its(:size) { should == 2 }
    its(:page) { should == 1 }
    its(:total_pages) { should == 1 }

    its(:documents) { should be_an_instance_of(Array) }
    its(:documents) { should have(2).items }
  end

  describe "#find" do
    let(:document) { collection.find(id) }

    context "when a document exists in the collection" do
      let(:mongo_document) { mongo_collection.find.first }
      let(:id) { mongo_document["_id"].to_s }

      it "returns a documents with the given id" do
        expect(document).not_to be_nil
        expect(document).to be_an_instance_of(MongoBrowser::Models::Document)
        expect(document.id.to_s).to eq(id)
      end
    end

    context "when the document does not exist" do
      let(:id) { "50b908f9dac5d53509000010" }

      it "returns nil" do
        expect(document).to be_nil
      end
    end
  end

  describe "#remove!" do
    let(:document) { MongoBrowser::Models::Document.new(db_name, collection_name, mongo_collection.find.first) }

    it "removes a document from the collection" do
      expect(collection.remove!(document)).to be_true
      expect(collection.find(document.id)).to be_nil
    end
  end
end
