require "spec_helper"

describe MongoBrowser::API::Collections do
  include ApiExampleGroup

  def app
    described_class
  end

  describe "collections" do
    let(:db_name) { "first_database" }

    describe_endpoint :get, "/databases/:db_name/collections" do
      it { should be_successful }

      describe "returned collections" do
        subject(:collections) { JSON.parse(response.body) }

        it { should_not be_empty }
        it("contains all collections") { expect(collections).to have(4).items }

        describe "a collection" do
          subject(:collection) { collections.find { |collection| collection["name"] == "first_collection" } }

          it { should_not be_nil }
          it("contains database name") { expect(collection["dbName"]).to eq("first_database") }
          it("contains collection name") { expect(collection["name"]).to eq("first_collection") }
          it("contains number of documents") { expect(collection["size"]).to eq(2) }
        end
      end
    end

    describe_endpoint :get, "/databases/:db_name/collections/:collection_name/stats" do
      let(:collection_name) { "first_collection" }

      it { should be_successful }

      it "returns stats for the collection with the given name" do
        stats = JSON.parse(response.body)
        expect(stats).not_to be_empty
      end
    end

    describe_endpoint :delete, "/databases/:db_name/collections/:collection_name" do
      let(:collection_name) { "first_collection" }

      before do
        expect { do_request }.to \
          change { server.database(db_name).collections.count }.by(-1)
      end

      it { should be_successful }

      it "deletes a collection with the given name" do
        data = JSON.parse(response.body)
        expect(data["success"]).to be_true
      end
    end
  end


end
