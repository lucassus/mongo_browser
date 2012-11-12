require 'spec_helper'

describe 'Home page', type: :request do
  before { visit '/' }

  specify do
    page.should have_content('Available databases')

    within 'table' do
      # TODO ...
    end

    click_link 'activecell_development'

    within 'table' do
      # TODO ...
    end
  end

end
