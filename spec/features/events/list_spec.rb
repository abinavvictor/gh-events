require 'features_helper'
require 'json'

describe 'events#list' do
  attr_reader :user_login
  attr_reader :user_id

  attr_reader :user_json
  attr_reader :events_json

  attr_reader :expected_events

  def stub_get_json(url, body)
    stub_request(:get, url).to_return(status: 200, body: body, headers: { content_type: 'application/json; charset=utf-8' })
  end

  before :all do
    @user_login = 'dmolesUC3'
    @user_id = 10374934

    @user_json = File.read(Rails.root.join('spec/data/user.json'))
    @events_json = File.read(Rails.root.join('spec/data/events.json'))
    @expected_events = JSON.parse(events_json)
  end

  before :each do
    stub_get_json("https://api.github.com/users/#{user_login}", user_json)
    stub_get_json("https://api.github.com/user/#{user_id}/events", events_json)
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