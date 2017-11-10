if ENV['CI'] == 'true'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.command_name 'RSpec'

  SimpleCov.start 'rails' do
    minimum_coverage 100
  end
  Coveralls.wear!
end

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
  config.default_formatter = 'doc' if config.files_to_run.one?
end
