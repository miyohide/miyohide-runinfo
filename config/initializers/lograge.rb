Rails.application.configure do
  path = File.join("#{Rails.root}", "log", "lograge_#{Rails.env}.log")
  config.lograge.logger = ActiveSupport::Logger.new path
  config.lograge.enabled = true
  config.lograge.keep_original_rails_log = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new

  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
      host: event.payload[:host],
      timestamp: event.time,
      params: event.payload[:params].except(*exceptions)
    }
  end
end
