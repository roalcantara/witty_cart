require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WittyCart
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end

  class << self
    def canonical_host
      ENV['CANONICAL_HOST'] || heroku_host || 'localhost:3000'
    end

    def heroku_host
      "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" if ENV['HEROKU_APP_NAME'].present?
    end

    def host
      [(Rails.env.production? ? 'https://' : 'http://'), canonical_host].join()
    end

    def env
      ENV['ENVIRONMENT'] || Rails.env
    end

    def production?
      env == 'production'
    end
  end
end
