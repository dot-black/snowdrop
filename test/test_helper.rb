require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Capybara.javascript_driver = :chrome

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
end

require 'fileutils'

# Carrierwave setup and teardown
carrierwave_template = Rails.root.join('test','fixtures','files')
carrierwave_root = Rails.root.join('test','support','carrierwave')

# Carrierwave configuration is set here instead of in initializer
CarrierWave.configure do |config|
  config.root = carrierwave_root
  config.enable_processing = false
  config.storage = :file
  config.cache_dir = Rails.root.join('test','support','carrierwave','carrierwave_cache')
end

at_exit do
  #puts "Removing carrierwave test directories:"
  Dir.glob(carrierwave_root.join('*')).each do |dir|
    #puts "   #{dir}"
    FileUtils.remove_entry(dir)
  end
end
