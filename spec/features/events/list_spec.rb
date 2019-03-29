require 'features_helper'
require 'json'

describe 'events#list' do
  include_context('user')
  include_context('events')

  attr_reader :expected_events

  before :all do
    @expected_events = JSON.parse(events_json)
  end

  before :each do
    visit("/events/#{user_login}")
  end

  describe 'displays the login' do
    it 'displays it somewhere' do
      expect(page).to have_content(user_login)
    end

    it 'displays it in an H1' do
      expect(page).to have_selector('h1', text: user_login)
    end
  end

  describe 'displays the events' do
    it 'displays the event IDs' do
      aggregate_failures 'event IDs' do
        expected_events.each do |event|
          expected_id = event[:id]
          expect(page).to have_selector('td', text: expected_id)
        end
      end
    end
  end
end