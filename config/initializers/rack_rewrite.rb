if ENV['SERVICE_DOMAIN'].present?
  # SERVICE_DOMAINと異なるドメインでアクセスした場合はSERVICE_DOMAINへリダイレクト
  Rediction::Application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    r301 %r{.*}, "https://#{ENV['SERVICE_DOMAIN']}$&", :if => Proc.new {|rack_env|
      rack_env['SERVER_NAME'] != ENV['SERVICE_DOMAIN']
    }
  end
end
