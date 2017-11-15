ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'support/factory_bot'

# # Configure the shared examples specs folder
# # https://www.relishapp.com/rspec/rspec-core/docs/example-groups/shared-examples
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.render_views
  config.include ActiveSupport::Testing::TimeHelpers

  # enables url_helpers for specs
  config.include Rails.application.routes.url_helpers
end
