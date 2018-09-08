class Rack::Attack
  # [対象] アクセス全て
  # [制限] 5分で300アクセスまで
  throttle('req/ip', limit: 2, period: 5.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  # [対象] ログイン(GET & POST)
  # [制限] 30秒で5アクセスまで
  throttle("logins/ip", limit: 10, period: 30.seconds) do |req|
    req.ip if req.path == '/login'
  end
end
