require "spec_helper"

describe "Documents list", type: :request, js: true do
  let(:connection) { Fixtures.instance.connection }

  before do
    visit "/"

    within("table.databases") { click_link "first_database" }
    within("table.collections") { click_link current_collection_name }
  end

  shared_examples "breadcrumbs for documents list" do
    it "displays the breadcrumb" do
      within ".breadcrumbs" do
        within "li:nth-child(1)" do
          expect(page).to have_link("first_database")
        end

        within "li:nth-child(2)" do
          expect(page).to have_link(current_collection_name, href: "#")
        end
      end
    end

    it "has a valid title" do
      within "h2" do
        expect(page).to have_content("#{current_collection_name} documents")
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

    it "displays information about the collection" do
      click_link "Stats"

      within "table" do
        %w(ns count size avgObjSize storageSize numExtents nindexes lastExtentSize paddingFactor systemFlags userFlags totalIndexSize indexSizes ok).each do |field|
          expect(page).to have_content(field)
        end
      end
    end

    describe "click on delete document button" do
      let(:document) do
        database = connection.db("first_database")
        collection = database.collection(current_collection_name)
        collection.find_one(name: "This is the second sample record")
      end

      it "removes a document from the collection" do
        click_delete_button_for(document)
        confirm_dialog

        expect(page).to have_flash_message("Document #{document["_id"]} has been deleted.")

        expect(page).to have_css("tr.document", count: 1)

        within "table" do
          expect(page).to have_content("This is a sample record")
          expect(page).not_to have_content(document["name"])
        end
      end

      def click_delete_button_for(document)
        database_row = find(:xpath, %Q{//table//tr/td[1][contains(text(), "#{document["_id"]}")]/..})
        within(database_row) { click_link "Delete" }
      end
    end
  end

  context "with large number of documents" do
    let(:current_collection_name) { "second_collection" }

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
