require 'sidekiq/testing'

RSpec.configure do |config|
  config.include ActiveJob::TestHelper

  config.before :suite do
    ActiveJob::Base.queue_adapter = :test
  end

  config.before :all do
    Sidekiq::Testing.fake!
  end

  config.before :each do
    Sidekiq::Worker.clear_all
  end
end
