# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Neo4j::RSpec::Matchers
  config.include FactoryBot::Syntax::Methods
  config.include Shoulda::Matchers::ActiveModel,  type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
