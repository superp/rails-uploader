# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'database_cleaner'

# Fixtures replacement with a straightforward definition syntax
require 'factory_girl'
FactoryGirl.definition_file_paths = [File.expand_path('../factories/', __FILE__)]
FactoryGirl.find_definitions

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = 'test.com'

Rails.backtrace_cleaner.remove_silencers!

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path('../dummy/db/migrate/', __FILE__)

require 'carrierwave'
CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = true
end

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers

  # == Mock Framework
  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :truncation
    DatabaseCleaner[:mongoid].strategy = :truncation if Object.const_defined?('Mongoid')
  end

  config.before(:all) do
    DatabaseCleaner[:active_record].start
    DatabaseCleaner[:mongoid].start if Object.const_defined?('Mongoid')
  end

  config.after(:all) do
    DatabaseCleaner[:active_record].clean
    DatabaseCleaner[:mongoid].clean if Object.const_defined?('Mongoid')
  end
end
