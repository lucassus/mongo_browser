require 'spec_helper'

describe 'Home page', type: :request do
  before { visit '/' }

  specify do
    page.should have_content('Available databases')

    within 'table' do
      page.should have_content('first_database')
      page.should have_content('second_database')
    end
  end

  specify do
    click_link 'first_database'

    within 'table' do
      page.should have_content('first_collection')
    end
  end

end
