require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'headless_chrome'

Capybara.javascript_driver = :headless_chrome

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
end
