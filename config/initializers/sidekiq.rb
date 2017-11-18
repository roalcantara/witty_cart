require 'sidekiq/web'

Sidekiq::Logging.logger.level = Rails.env.production? ? Logger::INFO : Logger::DEBUG
