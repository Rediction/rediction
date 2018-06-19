Rails.application.config.session_store :redis_store, {
  servers: ENV['REDIS_SESSION_URL'].presence || "redis://localhost:6379/0/session",
  expires_in: 1.month
}
