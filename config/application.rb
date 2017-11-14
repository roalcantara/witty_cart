require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WittyCart
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end

  class << self
    def canonical_host
      ENV['CANONICAL_HOST'] || 'localhost:3000'
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
