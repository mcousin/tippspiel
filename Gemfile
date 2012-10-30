source 'https://rubygems.org'

gem 'rails', '3.2.7'
gem 'bcrypt-ruby', '~> 3.0.0', :require => 'bcrypt'

# needed for haml
gem 'haml-rails'
gem 'hpricot'
gem 'ruby_parser'

gem 'savon' # soap client
gem 'fuzzy-string-match_pure'

gem 'will_paginate'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'debugger'
  gem 'sqlite3'
  gem 'rspec-rails'               # test framework
  gem 'shoulda-matchers'          # additional matchers for rspec tests
  gem 'capybara'                  # integration test framework
  gem 'mocha', :require => false  # mock framework
end

# needed for HEROKU
group :production, :staging do
  gem "pg"
  gem 'google-webfonts'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass_twitter_bootstrap'
  gem 'compass-rails'
  gem 'therubyracer'
  gem 'google-webfonts'
  gem 'compass-rails'  
end

gem 'jquery-rails'



# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

