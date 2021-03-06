Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # サービスのホストドメインを指定
  config.service_host = ENV["SERVICE_DOMAIN"] || "localhost:3000"

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}",
  }

  # ファイル保存先をS3に設定するかを示す
  config.attachment_use_s3 = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: "localhost:3000" }

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # OmniAuthをテストモードに設定
  OmniAuth.config.test_mode = true

  # env["omniauth.auth"]を設定
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    {
      provider: "google_oauth2",
      uid: "xxxxxxxxxxxxxxxxxxxxx",
      info: {email: "example@gmail.com"},
    }
  )
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  config.omniauth_env = Rails.application.env_config["omniauth.auth"]
end
