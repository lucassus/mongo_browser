require "spec_helper"

describe MongoBrowser::API::Documents do
  include ApiExampleGroup

  def app
    described_class
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
            it("responds with 403") { expect(response.status).to eq(403) }

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

      context "whe the document has been found" do
        it { should be_successful }

        it "returns the document" do
          data = JSON.parse(response.body)
          expect(data["id"]).to eq(id.to_s)
        end
      end

      context "when the documents has not been found" do
        before do
          collection = server.database(db_name).collection(collection_name)
          document = collection.find(id)
          collection.remove!(document)
        end

        it { should_not be_successful }
        its(:status) { should == 404 }

        it("should notify about not found document") do
          error = JSON.parse(response.body)["error"]
          expect(error).not_to be_nil
          expect(error).to eq("Document not found")
        end
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


end
