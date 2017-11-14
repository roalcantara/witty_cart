require 'devise'

# https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-3-and-4-(and-RSpec)
RSpec.configure do |config|
  %i(controller view helper).each do |type|
    config.include Devise::Test::ControllerHelpers, type: type
  end

  # https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
  config.include Warden::Test::Helpers
end
