# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'vcr'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include RequestSpecHelper, type: :request
  config.include Neo4j::RSpec::Matchers
  config.extend Helpers::ThingFieldsSpecHelper
  config.extend Helpers::LastMessagesSpecHelper
  config.extend Helpers::LastUplinkSpecHelper

  # For the `neo4j` gem
  config.around do |example|
    Neo4j::ActiveBase.run_transaction do |tx|
      example.run
      tx.mark_failed
    end
  end
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = Rails.root.join('spec', 'fixtures','vcr_cassettes')
  config.hook_into :faraday
  config.ignore_hosts 'neo4j_test'
end
