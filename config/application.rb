require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StrategicVoting
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.assets.precompile += %w(
      vendor
    )

    config.active_job.queue_adapter = :sucker_punch

    if ENV["MEMCACHEDCLOUD_SERVERS"]
      config.cache_store = :dalli_store, ENV["MEMCACHEDCLOUD_SERVERS"].split(','),
        { username: ENV["MEMCACHEDCLOUD_USERNAME"], password: ENV["MEMCACHEDCLOUD_PASSWORD"] }
    elsif Rails.env.development?
      puts "dev caching"
      config.cache_store = :dalli_store, "localhost"
    end
  end
end
