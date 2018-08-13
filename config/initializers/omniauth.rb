Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = "/admin/auth"
  end

  GOOGLE_AUTH_CLIENT_ID, GOOGLE_AUTH_CLIENT_SECRET =
    if Rails.env.development?
      # Local管理画面用
      ["217599276601-po4c2chshjq9h6qi1hqeamk38hab464l.apps.googleusercontent.com", "XqhOtF72nZXXsg-70mi9hM23"]
    else
      [ENV["GOOGLE_AUTH_CLIENT_ID"], ENV["GOOGLE_AUTH_CLIENT_SECRET"]]
    end

  provider :google_oauth2, GOOGLE_AUTH_CLIENT_ID, GOOGLE_AUTH_CLIENT_SECRET
end
