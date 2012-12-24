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
      subject(:response) { last_response }

      its(:status) { should == 200 }

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

      its(:status) { should == 200 }

      it "deletes a database with the given name" do
        data = JSON.parse(response.body)
        expect(data["success"]).to be_true
      end
    end

    describe "GET /databases/:db_name/stats.json" do
      let(:db_name) { "first_database" }

      before { get "/databases/#{db_name}/stats.json" }
      subject(:response) { last_response }

      its(:status) { should == 200 }

      it "gets stats for the given database" do
        stats = JSON.parse(response.body)
        expect(stats).to_not be_empty
      end
    end
  end

  describe "collections" do
    let(:db_name) { "first_database" }

    describe "GET /databases/:db_name/collections.json" do
      before { get "/databases/#{db_name}/collections.json" }
      subject(:response) { last_response }

      its(:status) { should == 200 }

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

      before { get "/databases/#{db_name}/collections/#{collection_name}/stats" }
      subject(:response) { last_response }

      its(:status) { should == 200 }

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

      its(:status) { should == 200 }

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
      before { get "/databases/#{db_name}/collections/#{collection_name}/documents" }
      subject(:response) { last_response }

      its(:status) { should == 200 }

      it "returns a list of paginated documents" do
        paged_documents = JSON.parse(response.body)

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
      subject(:response) { last_response }

      its(:status) { should == 200 }

      it "deletes a document with the given id" do
        data = JSON.parse(response.body)
        expect(data["success"]).to be_true
      end
    end
  end

  describe "GET /server_info.json" do
    before { get "/server_info.json" }
    subject(:response) { last_response }

    its(:status) { should == 200 }

    it "returns info about the server" do
      server_info = JSON.parse(response.body)
      expect(server_info).to_not be_empty
    end
  end

  describe "GET /version.json" do
    before { get "/version.json" }
    subject(:response) { last_response }

    its(:status) { should == 200 }

    it "returns application version" do
      data = JSON.parse(response.body)
      expect(data["version"]).to eq(MongoBrowser::VERSION)
    end
  end
end
