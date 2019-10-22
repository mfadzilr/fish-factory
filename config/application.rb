require_relative 'boot'

require 'roo'
require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fishfactory
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.before_configuration do
        env_file = File.join(Rails.root, 'config', 'local_env.yml')
        YAML.load(File.open(env_file)).each do |key, value|
            ENV[key.to_s] = value
        end if File.exists?(env_file)
    end
    config.to_prepare do
      Devise::SessionsController.layout "login"
      # Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application" : "login" }
      # Devise::ConfirmationsController.layout "login"
      # Devise::UnlocksController.layout "login"            
      # Devise::PasswordsController.layout "login"        
    end

  end
end
