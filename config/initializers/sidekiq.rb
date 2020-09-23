require 'redis'
require 'datadog/statsd'

redis_conf = YAML.safe_load(ERB.new(File.read(Rails.root.join("config", "redis.yml"))).result, [Symbol], [], true)["sidekiq"]

Redis.current = Redis.new(redis_conf)

redis_settings = {url: Redis.current.id}

Sidekiq.configure_client do |config|
  config.redis = redis_settings
end

if Sidekiq::Client.method_defined? :reliable_push!
  Sidekiq::Client.reliable_push!
end

Sidekiq.configure_server do |config|
  Sidekiq::Logging.logger.level = Logger::FATAL unless Rails.env.development?

  Rails.logger = Sidekiq::Logging.logger

  config.super_fetch!
  config.reliable_scheduler!
  config.redis = redis_settings
end

Sidekiq.default_worker_options = {
  backtrace: false,
  # Set uniqueness lock expiration to 24 hours to balance preventing
  # duplicate jobs from running (if uniqueness time is too short)
  unique_job_expiration: 24.hours
}

unless Rails.env.development? || Rails.env.test?
  Sidekiq::Pro.dogstatsd = -> { Datadog::Statsd.new(ENV['DATADOG_HOST'], ENV['DATADOG_PORT']) }
end
