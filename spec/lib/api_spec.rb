require "spec_helper"

describe MongoBrowser::Api do
  include Rack::Test::Methods

  def app
    described_class
  end

  let(:server) { MongoBrowser::Models::Server.current }

  describe "databases" do
    describe "GET /databases.json" do
      subject(:response) { get "/databases.json" }

      it { should be_successful }

      describe "returned databases" do
        subject(:data) { JSON.parse(response.body) }

        it { should_not be_empty }
        it("contains all databases") { should have(3).items }

        describe "a database" do
          subject(:database) { data.find { |db| db["name"] == "first_database" } }

          it { should_not be_nil }
          it("contains name") { expect(database["name"]).to eq("first_database") }
          it("contains number of collections") { expect(database["count"]).to eq(4) }
        end
      end
    end

    describe "DELETE /databases/:db_name.json" do
      let(:db_name) { "first_database" }

      before do
        expect do
          delete "/databases/#{db_name}.json"
        end.to change { server.databases.count }.by(-1)
      end
      subject(:response) { last_response }

      it { should be_successful }

      it "deletes a database with the given name" do
        data = JSON.parse(response.body)
        expect(data["success"]).to be_true
      end
    end

    describe "GET /databases/:db_name/stats.json" do
      let(:db_name) { "first_database" }
      subject(:response) { get "/databases/#{db_name}/stats.json" }

      it { should be_successful }

      it "gets stats for the given database" do
        stats = JSON.parse(response.body)
        expect(stats).to_not be_empty
      end
    end
  end

  describe "collections" do
    let(:db_name) { "first_database" }

    describe "GET /databases/:db_name/collections.json" do
      subject(:response) { get "/databases/#{db_name}/collections.json" }

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

    describe "GET /databases/:db_name/collections/:collection_name/stats" do
      let(:collection_name) { "first_collection" }
      subject(:response) { get "/databases/#{db_name}/collections/#{collection_name}/stats" }

      it { should be_successful }

      it "returns stats for the collection with the given name" do
        stats = JSON.parse(response.body)
        expect(stats).not_to be_empty
      end
    end

    describe "DELETE /databases/:db_name/collections/first_collection" do
      let(:collection_name) { "first_collection" }

      before do
        expect do
          delete "/databases/#{db_name}/collections/#{collection_name}"
        end.to change { server.database("first_database").collections.count }.from(4).to(3)
      end
      subject(:response) { last_response }

      it { should be_successful }

      it "deletes a collection with the given name" do
        data = JSON.parse(response.body)
        expect(data["success"]).to be_true
      end
    end
  end

  describe "documents" do
    let(:db_name) { "first_database" }
    let(:collection_name) { "first_collection" }

    describe "GET /databases/:db_name/collections/:collection_name/documents" do
      subject(:response) { get "/databases/#{db_name}/collections/#{collection_name}/documents" }

      it { should be_successful }

      describe "returned documents" do
        subject(:data) { JSON.parse(response.body) }

        it("contains the current page") { expect(data["page"]).to equal(1) }
        it("contains size") { expect(data["size"]).to equal(2) }
        it("contains total pages") { expect(data["totalPages"]).to equal(1) }
        it("contains all documents") do
          expect(data["documents"]).not_to be_nil
          expect(data["documents"]).to have(2).items
        end

        describe "a document" do
          subject(:document) { data["documents"].first }

          it { should_not be_nil }
          it("contains id") { expect(document["id"]).to_not be_nil }
          it("contains document data") { expect(document["data"]).to_not be_nil }
        end
      end
    end

    describe "DELETE /databases/:db_name/collections/:collection_name/documents/:id" do
      let(:id) do
        document = server.database(db_name).collection(collection_name).mongo_collection.find({}, limit: 1).first
        document["_id"]
      end

      before do
        expect do
          delete "/databases/#{db_name}/collections/#{collection_name}/documents/#{id}"
        end.to change { server.database(db_name).collection(collection_name).size }.from(2).to(1)
      end
      subject(:response) { last_response }

      it { should be_successful }

      it "deletes a document with the given id" do
        data = JSON.parse(response.body)
        expect(data["success"]).to be_true
      end
    end
  end

  describe "GET /server_info.json" do
    subject(:response) { get "/server_info.json" }

    it { should be_successful }

    it "returns info about the server" do
      server_info = JSON.parse(response.body)
      expect(server_info).to_not be_empty
    end
  end

  describe "GET /version.json" do
    subject(:response) { get "/version.json" }

    it { should be_successful }

    it "returns application version" do
      data = JSON.parse(response.body)
      expect(data["version"]).to eq(MongoBrowser::VERSION)
    end
  end
end
