require 'features_helper'

describe 'index' do
  before(:each) do
    visit('/')
  end

  it 'is a page' do
    expect(page.title).not_to be_empty
  end
end
