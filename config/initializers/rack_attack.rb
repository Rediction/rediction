class Rack::Attack
  # [対象] アクセス全て
  # [制限] 1分で100アクセスまで
  throttle('req/ip/1m', limit: 100, period: 1.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  # [対象] アクセス全て
  # [制限] 5分で300アクセスまで
  throttle('req/ip/5m', limit: 300, period: 5.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  # [対象] ログイン(GET & POST)
  # [制限] 30秒で10アクセスまで
  throttle("logins/ip", limit: 10, period: 30.seconds) do |req|
    req.ip if req.path == '/login'
  end
end
