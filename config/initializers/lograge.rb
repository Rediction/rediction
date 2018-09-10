Rails.application.configure do
  path = "#{Rails.root}/log/lograge_#{Rails.env}.log"
  config.lograge.logger = ActiveSupport::Logger.new(path)
  config.lograge.enabled = true
  config.lograge.keep_original_rails_log = true
  config.lograge.formatter = Lograge::Formatters::LTSV.new
  config.lograge.base_controller_class = "::ApplicationController"

  # user_id以外のrequest情報を格納している。
  # user_idは継承元のControllerによって取得方法が異なるので、
  # 各継承元のControllerで個別にpayloadに格納するように実装している。
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      ip: controller.request.remote_ip,
      referer: controller.request.referer,
      user_agent: controller.request.user_agent
    }
  end

  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format authenticity_token)
    data = {
      level: 'info',
      user_id: event.payload[:user_id],
      time: event.time,
      params: event.payload[:params].except(*exceptions)
    }

    if event.payload[:exception]
      data[:level] = 'fatal'
      data[:exception] = event.payload[:exception]
      data[:exception_backtrace] = event.payload[:exception_object].backtrace[0..6]
    end

    data
  end
end
