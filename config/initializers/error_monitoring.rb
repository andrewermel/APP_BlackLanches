# Error Monitoring Configuration
# Uncomment and configure when ready for production monitoring

# if Rails.env.production?
#   # Sentry Configuration
#   Sentry.init do |config|
#     config.dsn = ENV['SENTRY_DSN']
#     config.breadcrumbs_logger = [:active_support_logger, :http_logger]
#     config.traces_sample_rate = 0.1
#     config.send_default_pii = false
#     config.environment = Rails.env
#     config.release = ENV['APP_VERSION'] || 'unknown'
#   end
# end

# Development error handling
if Rails.env.development?
  # Enhanced error reporting for development
  Rails.application.configure do
    # Show full error reports
    config.consider_all_requests_local = true

    # Enable detailed error pages
    config.debug_exception_response_format = :default
  end
end

# Custom error handler for production
if Rails.env.production?
  Rails.application.configure do
    # Custom error pages
    config.exceptions_app = ->(env) {
      ErrorsController.action(:show).call(env)
    }
  end
end
