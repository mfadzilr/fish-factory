Sidekiq.default_worker_options = { retry: 0 }
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/12' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/12' }
end
