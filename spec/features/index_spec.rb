require 'features_helper'

describe 'index' do
  before(:each) do
    visit('/')
  end

  it 'is a page' do
    expect(page.title).not_to be_empty
  end

  describe 'get started form' do
    it 'accepts a GitHub login' do
      expect(page).to have_field('//[@id="login"')
      expect(page).to have_button('//[@id="submit"')

      user_login = 'dmolesUC3'
      fill_in('login', with: user_login)
      click_button('submit')
    end
  end
end
