require "spec_helper"

describe MongoBrowser::Api do
  include ApiExampleGroup

  def app
    described_class
  end

  describe "databases" do
    describe_endpoint :get, "/databases" do
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

    describe_endpoint :delete, "/databases/:db_name" do
      let(:db_name) { "first_database" }

      before do
        expect { do_request }.to \
          change { server.databases.count }.by(-1)
      end

      it { should be_successful }

      it "deletes a database with the given name" do
        data = JSON.parse(response.body)
        expect(data["success"]).to be_true
      end
    end

    describe_endpoint :get, "/databases/:db_name/stats" do
      let(:db_name) { "first_database" }

      it { should be_successful }

      it "gets stats for the given database" do
        stats = JSON.parse(response.body)
        expect(stats).to_not be_empty
      end
    end
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

  describe "documents" do
    let(:db_name) { "first_database" }
    let(:collection_name) { "first_collection" }

    describe "paged documents list" do
      shared_examples :returned_documents do
        it("contains all documents") do
          expect(data["documents"]).not_to be_nil
          expect(data["documents"]).to have_at_least(1).item
        end

        describe "a document" do
          subject(:document) { data["documents"].first }

          it { should_not be_nil }
          it("contains id") { expect(document["id"]).to_not be_nil }
          it("contains document data") { expect(document["data"]).to_not be_nil }
        end
      end

      describe_endpoint :get, "/databases/:db_name/collections/:collection_name/documents" do
        it { should be_successful }

        describe "returned documents" do
          subject(:data) { JSON.parse(response.body) }

          it("contains the current page") { expect(data["page"]).to equal(1) }
          it("contains size") { expect(data["size"]).to equal(2) }
          it("contains total pages") { expect(data["totalPages"]).to equal(1) }

          include_examples :returned_documents
        end
      end

      describe "for a large set of documents" do
        before { Fixtures.instance.load_documents! }
        let(:collection_name) { "second_collection" }

        describe_endpoint :get, "/databases/:db_name/collections/:collection_name/documents?page=:page" do
          let(:page) { 3 }

          it { should be_successful }

          describe "returned documents" do
            subject(:data) { JSON.parse(response.body) }

            it("contains the current page") { expect(data["page"]).to equal(3) }
            it("contains size") { expect(data["size"]).to equal(70) }
            it("contains total pages") { expect(data["totalPages"]).to equal(3) }

            include_examples :returned_documents
          end

          context "when the page number is invalid" do
            let(:page) { "invalid" }

            it { should_not be_successful }
            it("responds with 400") { expect(response.status).to eq(400) }

            it("should notify about invalid param") do
              error = JSON.parse(response.body)["error"]
              expect(error).not_to be_nil
              expect(error).to eq("invalid parameter: page")
            end
          end
        end
      end
    end

    describe_endpoint :get, "/databases/:db_name/collections/:collection_name/documents/:id" do
      let(:id) do
        document = server.database(db_name).collection(collection_name).mongo_collection.find({}, limit: 1).first
        document["_id"]
      end

      it { should be_successful }

      it "returns the document" do
        data = JSON.parse(response.body)
        expect(data["id"]).to eq(id.to_s)
      end
    end

    describe_endpoint :delete, "/databases/:db_name/collections/:collection_name/documents/:id" do
      let(:id) do
        document = server.database(db_name).collection(collection_name).mongo_collection.find({}, limit: 1).first
        document["_id"]
      end

      before do
        expect { do_request }.to \
          change { server.database(db_name).collection(collection_name).size }.by(-1)
      end

      it { should be_successful }

      it "deletes a document with the given id" do
        data = JSON.parse(response.body)
        expect(data["success"]).to be_true
      end
    end
  end

  describe_endpoint :get, "/server_info" do
    it { should be_successful }

    it "returns info about the server" do
      server_info = JSON.parse(response.body)
      expect(server_info).to_not be_empty
    end
  end

  describe_endpoint :get, "/version" do
    it { should be_successful }

    it "returns application version" do
      data = JSON.parse(response.body)
      expect(data["version"]).to eq(MongoBrowser::VERSION)
    end
  end
end
