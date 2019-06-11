# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
<<<<<<< HEAD

=======
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
>>>>>>> change to manual versioning
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
<<<<<<< HEAD
  #config.include Shoulda::Matchers::ActiveModel,  type: :model
  #config.include Shoulda::Matchers::ActiveRecord, type: :model

  #config.before(:suite) do
  #  FactoryBot.find_definitions
  #end
=======
  config.include Shoulda::Matchers::ActiveModel,  type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include RequestSpecHelper, type: :request
>>>>>>> change to manual versioning

  # For the `neo4j` gem
  config.around do |example|
    Neo4j::ActiveBase.run_transaction do |tx|
      example.run
      tx.mark_failed
    end
  end
end
