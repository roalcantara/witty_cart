# Witty Cart

### Development
* Node in order to provide a proxy to a external valid https domain

## Setup the project

1. `$ git clone <REPOSITORY_URL>` - Clone the project
2. `$ cd witty_cart` - Go into the project folder
3. `$ gem install bundler foreman` - Install bundler
4. `$ bundle install` - Install the dependencies
5. `$ bundle exec rake db:setup` - Setup the database
6. `$ npm install -g localtunnel`

## Running the project

1. `$ foreman start` - Starts the server via Foreman
2. `$ lt --port 3000 --subdomain ewebhooks` - Starts the proxy to a https://ewebhooks.localtunnel.me which will be used to handle PayPal webhooks
3. Open [http://localhost:3000](http://localhost:3000)

## Running specs

`$ bundle exec rake spec` to run the specs.

## References

### Tests

* [rspec-rails](https://relishapp.com/rspec/rspec-rails/docs)
* [shoulda-matchers](http://matchers.shoulda.io/)

### Proxy
* [localtunnel](https://localtunnel.github.io/www/)

### Jobs
* [sidekiq](https://github.com/mperham/sidekiq)

## How to contribute :heart_eyes:

Follow the [Git Flow](http://nvie.com/posts/a-successful-git-branching-model/)
