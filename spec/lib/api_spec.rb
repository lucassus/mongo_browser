require "spec_helper"

# TODO cleanup specs, write custom machers / macros
describe MongoBrowser::Api do
  include Rack::Test::Methods

  def app
    described_class
  end

  let(:server) { MongoBrowser::Models::Server.current }

  describe "databases" do
    describe "GET /databases.json" do
      before { get "/databases.json" }

      it "returns a list of all available databases" do
        expect(last_response.status).to be(200)
        databases = JSON.parse(last_response.body)
        expect(databases).to have(3).items

        first_database = databases.find { |db| db["name"] == "first_database" }
        expect(first_database).to_not be_nil
        expect(first_database["name"]).to eq("first_database")
        expect(first_database["count"]).to eq(4)
      end
    end

    describe "DELETE /databases/:db_name.json" do
      let(:db_name) { "first_database" }

      before do
        expect do
          delete "/databases/#{db_name}.json"
        end.to change { server.databases.count }.from(3).to(2)
      end

      it "deletes a database with the given name" do
        expect(last_response.status).to be(200)
        response = JSON.parse(last_response.body)
        expect(response["success"]).to be_true
      end
    end

    describe "GET /databases/:db_name/stats.json" do
      let(:db_name) { "first_database" }

      before { get "/databases/#{db_name}/stats.json" }

      it "gets stats for the given database" do
        expect(last_response.status).to be(200)
        stats = JSON.parse(last_response.body)
        expect(stats).to_not be_empty
      end
    end
  end

  describe "collections" do
    let(:db_name) { "first_database" }

    describe "GET /databases/:db_name/collections.json" do
      before { get "/databases/#{db_name}/collections.json" }

      it "returns a list of all available collections for the given database" do
        expect(last_response.status).to be(200)
        collections = JSON.parse(last_response.body)
        expect(collections).to have(4).items

        first_collection = collections.find { |collection| collection["name"] == "first_collection" }
        expect(first_collection).to_not be_nil
        expect(first_collection["dbName"]).to eq("first_database")
        expect(first_collection["name"]).to eq("first_collection")
        expect(first_collection["size"]).to eq(2)
      end
    end

    describe "GET /databases/:db_name/collections/:collection_name/stats" do
      let(:collection_name) { "first_collection" }

      before { get "/databases/#{db_name}/collections/#{collection_name}/stats" }

      it "returns stats for the collection with the given name" do
        expect(last_response.status).to be(200)
        stats = JSON.parse(last_response.body)
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

      it "deletes a collection with the given name" do
        expect(last_response.status).to be(200)
        response = JSON.parse(last_response.body)
        expect(response["success"]).to be_true
      end
    end
  end

  describe "documents" do
    let(:db_name) { "first_database" }
    let(:collection_name) { "first_collection" }

    describe "GET /databases/:db_name/collections/:collection_name/documents" do
      before { get "/databases/#{db_name}/collections/#{collection_name}/documents" }

      it "returns a list of paginated documents" do
        expect(last_response.status).to be(200)
        paged_documents = JSON.parse(last_response.body)

        expect(paged_documents["page"]).to equal(1)
        expect(paged_documents["size"]).to equal(2)
        expect(paged_documents["totalPages"]).to equal(1)

        expect(paged_documents["documents"]).not_to be_nil
        expect(paged_documents["documents"]).to have(2).items

        first_document = paged_documents["documents"].first
        expect(first_document).to_not be_nil
        expect(first_document["id"]).to_not be_nil
        expect(first_document["data"]).to_not be_nil
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

      it "deletes a document with the given id" do
        expect(last_response.status).to be(200)
        response = JSON.parse(last_response.body)
        expect(response["success"]).to be_true
      end
    end
  end

  describe "GET /server_info.json" do
    before { get "/server_info.json" }

    it "returns info about the server" do
      expect(last_response.status).to be(200)
      databases = JSON.parse(last_response.body)
      expect(databases).to_not be_empty
    end
  end

  describe "GET /version.json" do
    before { get "/version.json" }

    it "returns application version" do
      expect(last_response.status).to be(200)
      databases = JSON.parse(last_response.body)
      expect(databases["version"]).to eq(MongoBrowser::VERSION)
    end
  end
end
