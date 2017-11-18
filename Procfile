release: bundle exec rake db:migrate db:seed
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -v -C config/sidekiq.yml
