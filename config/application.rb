require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module McollectorApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.autoload_paths << "#{root}/app/workers"
    config.autoload_paths << "#{root}/lib"

    config.i18n.default_locale = :ru
    config.i18n.locale = :ru

    config.time_zone = 'Moscow'

    config.active_job.queue_adapter = :sidekiq

    config.to_prepare do
      Devise::SessionsController.layout proc{ |controller| user_signed_in? ? 'application_logged' : 'application' }
      Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? 'application_logged' : 'application' }
      Devise::ConfirmationsController.layout proc{ |controller| user_signed_in? ? 'application_logged' : 'application' }
      Devise::UnlocksController.layout proc{ |controller| user_signed_in? ? 'application_logged' : 'application' }
      Devise::PasswordsController.layout proc{ |controller| user_signed_in? ? 'application_logged' : 'application' }
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
