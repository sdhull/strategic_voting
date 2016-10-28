source 'https://rubygems.org'

ruby ENV["CUSTOM_RUBY_VERSION"] || '2.3.0'

gem 'active_hash'
gem 'actionpack-action_caching', github: "eileencodes/actionpack-action_caching", branch: "upgrade-to-rails-5"
gem 'awesome_print'
gem 'coffee-rails', '~> 4.2'
gem 'dalli'
gem 'devise'
gem 'devise-async', "~> 0.10.2", github: "mhfs/devise-async", branch: "devise-4.x"
gem 'foundation-icons-sass-rails'
gem 'foundation-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'haml'
gem 'inky-rb', require: 'inky', github: "sdhull/inky-rb", branch: "fix-heroku"
gem 'griddler'
gem 'griddler-mailgun'
gem 'newrelic_rpm'
gem 'nokogiri'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'pg', '~> 0.18'
gem 'premailer-rails'
gem 'puma'
gem 'rack-canonical-host'
gem 'rack-timeout'
gem 'rails', '~> 5.0.0'
gem 'rollbar'
gem 'sass-rails', '~> 5.0'
gem 'sucker_punch'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'validates_email_format_of'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem "rspec-rails"
  gem "capybara"
  gem "selenium-webdriver"
end
