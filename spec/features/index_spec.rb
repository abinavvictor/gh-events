require 'features_helper'

describe 'home' do
  before(:each) do
    visit('/')
  end

  it 'is a page' do
    expect(page.title).not_to be_empty
  end

  describe 'get started form' do
    include_context('user')
    include_context('events')

    it 'accepts a GitHub login' do
      expect(page).to have_field('login')
      expect(page).to have_button('submit')

      user_login = 'dmolesUC3'
      fill_in('login', with: user_login)
      click_button('submit')

      expected_path = url_for(controller: 'events', action: 'index', login: user_login, only_path: true)
      expect(page).to have_current_path(expected_path)
    end
  end
end
