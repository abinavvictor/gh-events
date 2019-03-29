require 'rails_helper'

require 'capybara/dsl'
require 'capybara/rails'
require 'capybara/rspec'
require 'webmock/rspec'

# ------------------------------------------------------------
# Capybara etc.

Capybara.register_driver(:selenium) do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(args: %w[incognito no-sandbox disable-gpu])
  )
end

Capybara.javascript_driver = :chrome

Capybara.configure do |config|
  config.default_max_wait_time = 10
  config.default_driver = :selenium
  config.server_port = 33_000
  config.app_host = 'http://localhost:33000'
end

Capybara.server = :puma

# ------------------------------------------------------------
# Capybara helpers

def wait_for_ajax!
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until page.evaluate_script("(typeof Ajax === 'undefined') ? 0 : Ajax.activeRequestCount").zero?
  end
end

# ------------------------------------------------------------
# RSpec configuration

RSpec.configure do |config|
  config.before(:each) do
    WebMock.disable_net_connect!(
      allow_localhost: true,
      allow: 'chromedriver.storage.googleapis.com'
    )
  end
end

# ------------------------------------------------------------
# RSpec shared context

def stub_get_json(url, body)
  stub_request(:get, url).to_return(
    status: 200,
    body: body,
    headers: { content_type: 'application/json; charset=utf-8' }
  )
end

RSpec.configure do |config|
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context('user', shared_context: :metadata) do
  attr_reader :user_login
  attr_reader :user_id
  attr_reader :user_json

  before :all do
    @user_login = 'dmolesUC3'
    @user_id = 10_374_934
    @user_json = File.read(Rails.root.join('spec/data/user.json'))
  end

  before :each do
    stub_get_json("https://api.github.com/users/#{user_login}", user_json)
  end
end

RSpec.shared_context('events', shared_context: :metadata) do
  attr_reader :events_json

  before :all do
    @events_json = File.read(Rails.root.join('spec/data/events.json'))
  end

  before :each do
    stub_get_json("https://api.github.com/user/#{user_id}/events", events_json)
  end
end

RSpec.configure do |config|
  config.include_context('user', included_shared: true)
  config.include_context('events', included_shared: true)
end
