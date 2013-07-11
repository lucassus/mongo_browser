require "spec_helper"

describe MongoBrowser::Api::Databases do
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
        it("contains all databases") { should have_at_least(3).items }

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

end
