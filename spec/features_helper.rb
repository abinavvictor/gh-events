require 'rails_helper'

require 'capybara/dsl'
require 'capybara/rails'
require 'capybara/rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    WebMock.disable_net_connect!(
      allow_localhost: true,
      allow: 'chromedriver.storage.googleapis.com'
    )
  end
end

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
