require "spec_helper"

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
      end
    end

    describe "DELETE /databases/first_database.json" do
      before do
        expect do
          delete "/databases/first_database.json"
        end.to change { server.databases.count }.from(3).to(2)
      end

      it "deletes a database with the given name" do
        expect(last_response.status).to be(200)
        response = JSON.parse(last_response.body)
        expect(response["success"]).to be_true
      end
    end

    describe "GET /databases/first_database/stats.json" do
      before { get "/databases/:db_name/stats.json" }

      it "gets stats for the given database" do
        expect(last_response.status).to be(200)
        stats = JSON.parse(last_response.body)
        expect(stats).to_not be_empty
      end
    end
  end

  describe "collections" do
    describe "GET /databases/first_database/collections.json" do
      before { get "/databases/first_database/collections.json" }

      it "returns a list of all available collections for the given database" do
        expect(last_response.status).to be(200)
        databases = JSON.parse(last_response.body)
        expect(databases).to have(4).items
      end
    end

    describe "GET /databases/first_database/collections/first_collection/stats" do
      before { get "/databases/first_database/collections/first_collection/stats" }

      it "returns stats for the collection with the given name" do
        expect(last_response.status).to be(200)
        stats = JSON.parse(last_response.body)
        expect(stats).not_to be_empty
      end
    end

    describe "DELETE /databases/first_database/collections/first_collection" do
      before do
        expect do
          delete "/databases/first_database/collections/first_collection"
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
    describe "GET /databases/first_database/collections/first_collection/documents" do
      before { get "/databases/first_database/collections/first_collection/documents" }

      it "returns a list of paginated documents" do
        expect(last_response.status).to be(200)
        databases = JSON.parse(last_response.body)

        expect(databases["documents"]).to have(2).items
        expect(databases["size"]).to equal(2)
        expect(databases["page"]).to equal(1)
        expect(databases["totalPages"]).to equal(1)
      end
    end

    describe "DELETE /databases/first_database/collections/first_collection/documents/:id" do
      let(:id) do
        document = server.database("first_database").collection("first_collection").mongo_collection.find({}, limit: 1).first
        document["_id"]
      end

      before do
        expect do
          delete "/databases/first_database/collections/first_collection/documents/#{id}"
        end.to change { server.database("first_database").collection("first_collection").size }.from(2).to(1)
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
