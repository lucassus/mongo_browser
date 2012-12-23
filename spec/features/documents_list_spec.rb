require "spec_helper"

describe "Documents list", type: :request, js: true do
  let(:connection) { Fixtures.instance.connection }

  before do
    visit "/"

    within("table.databases") { click_link "first_database" }
    within("table.collections") { click_link current_collection_name }
  end

  shared_examples "breadcrumbs for documents list" do
    xit "displays the breadcrumb" do
      within ".breadcrumbs" do
        within "li:nth-child(1)" do
          expect(page).to have_link("first_database")
        end

        within "li:nth-child(2)" do
          href = "/databases/first_database/collections/#{current_collection_name}/documents"
          expect(page).to have_link(current_collection_name, href: href)
        end
      end
    end

    xit "has a valid title" do
      within "h2" do
        expect(page).to have_content("#{current_collection_name} documents")
      end
    end
  end

  context "with small number for documents" do
    let(:current_collection_name) { "first_collection" }

    include_examples "breadcrumbs for documents list"

    xit "displays all documents for the selected collection" do
      expect(page).to have_css("tr.document", count: 2)

      within "table" do
        expect(page).to have_content("This is a sample record")
        expect(page).to have_content("This is the second sample record")
      end
    end

    xit "displays information about the collection" do
      click_link "Collection stats"

      within "table" do
        %w(ns count size avgObjSize storageSize numExtents nindexes lastExtentSize paddingFactor totalIndexSize indexSizes ok).each do |field|
          expect(page).to have_content(field)
        end
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

    xit "displays a pagination" do
      expect(page).to have_css("div.pagination", count: 2)
      within "div.pagination" do
        (1..3).each do |n|
          expect(page).to have_link(n.to_s)
        end
      end
    end

    xit "paginates documents" do
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
