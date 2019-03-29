require 'features_helper'
require 'json'

describe 'events#list' do
  describe 'user found' do
    include_context('user')
    include_context('events')

    attr_reader :expected_events

    before :all do
      @expected_events = JSON.parse(events_json)
    end

    before :each do
      visit("/events/#{user_login}")
    end

    it 'displays expected basic content' do
      expect(page).to have_content(user_login)
      expect(page).to have_selector('h1', text: user_login)

      expect(page).to have_content('Page 1 of 1')

      expect(page).to have_link('home', href: '/')
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

  describe 'pagination' do
    include_context('user')

    attr_reader :events_page_3_json
    attr_reader :events_page_3_url
    attr_reader :expected_events

    before :all do
      @events_page_3_url = event_list_url(user_id) + '?page=3'
      @events_page_3_json = File.read(Rails.root.join('spec/data/events-page-3.json'))
      @expected_events = JSON.parse(events_page_3_json)
    end

    before :each do
      links = {
        prev: 'https://api.github.com/user/10374934/events?page=2',
        next: 'https://api.github.com/user/10374934/events?page=4',
        last: 'https://api.github.com/user/10374934/events?page=10'
      }
      link_header = 'Link: ' + links.to_a.map { |rel, href| "<#{href}>; rel=\"#{rel}\"" }.join(', ')

      stub_get_json(events_page_3_url, events_page_3_json, headers: { Link: link_header })
      visit("/events/#{user_login}?page=3")
    end

    it 'displays expected basic content' do
      expect(page).to have_content(user_login)
      expect(page).to have_selector('h1', text: user_login)

      expect(page).to have_content('Page 3 of 10')

      expect(page).to have_link('home', href: '/')
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

  describe 'user not found' do
    attr_reader :bad_user
    attr_reader :user_not_found_json

    before :all do
      @bad_user = 'not-a-user'
      @user_not_found_json = File.read(Rails.root.join('spec/data/user_not_found.json'))
    end

    before :each do
      stub_get_json(user_url(bad_user), user_not_found_json, status: 404)
      visit("/events/#{bad_user}")
    end

    it 'displays a custom error page' do
      expect(page).not_to have_content('Puma caught this error')
      expect(page).to have_content("The user ‘#{bad_user}’ could not be found.")

      expect(page).to have_link('home', href: '/')
    end
  end

  # Probably not normally possible to get 404 for events,
  # if we didn't get one for the user, but let's be sure
  describe 'events not found' do
    include_context('user')

    attr_reader :events_not_found_json

    before :all do
      @events_not_found_json = File.read(Rails.root.join('spec/data/events_not_found.json'))
    end

    before :each do
      stub_get_json(event_list_url(user_id), events_not_found_json, status: 404)
      visit("/events/#{user_login}")
    end

    it 'displays a custom error page' do
      expect(page).not_to have_content('Puma caught this error')
      expect(page).to have_content("The user ‘#{user_login}’ could not be found.")

      expect(page).to have_link('home', href: '/')
    end
  end
end
