require "spec_helper"

describe "Documents list", type: :request do
  before do
    visit "/"

    within("table.databases") { click_link "first_database" }
    within("table.collections") { click_link current_collection_name }
  end

  shared_examples "breadcrumbs for documents list" do
    it "displays the breadcrumb" do
      within ".breadcrumb" do
        within "li:nth-child(1)" do
          expect(page).to have_link("Databases")
        end

        within "li:nth-child(2)" do
          expect(page).to have_link("db: first_database")
        end

        within "li:nth-child(3)" do
          expect(page).to have_content("collection: #{current_collection_name}")
        end
      end
    end
  end

  context "with small number for documents" do
    let(:current_collection_name) { "first_collection" }

    include_examples "breadcrumbs for documents list"

    it "displays all documents for the selected collection" do
      expect(page).to have_css("tr.document", count: 2)

      within "table" do
        expect(page).to have_content("This is a sample record")
        expect(page).to have_content("This is the second sample record")
      end
    end
  end

  context "with large number of documents" do
    let(:current_collection_name) { "second_collection" }
    let(:connection) { MongoTestServer.connection }

    before do
      database = connection.db("first_database")
      collection = database.collection(current_collection_name)

      70.times do |n|
        collection.insert(name: "Document #{n}", position: n)
      end

      visit current_path
    end

    include_examples "breadcrumbs for documents list"

    it "displays a pagination" do
      expect(page).to have_css("div.pagination", count: 2)
      within "div.pagination" do
        (1..3).each do |n|
          expect(page).to have_link(n.to_s)
        end
      end
    end

    it "paginates documents" do
      within "table.documents" do
        (0...25).each do |n|
          expect(page).to have_content("Document #{n}")
        end
      end

      within "div.pagination" do
        click_link "2"
      end

      within "table.documents" do
        (25...50).each do |n|
          expect(page).to have_content("Document #{n}")
        end
      end

      within "div.pagination" do
        click_link "3"
      end

      within "table.documents" do
        (50...70).each do |n|
          expect(page).to have_content("Document #{n}")
        end
      end
    end
  end
end
