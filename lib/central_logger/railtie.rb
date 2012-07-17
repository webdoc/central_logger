if Rails::VERSION::MAJOR == 3
  class Railtie < Rails::Railtie
    include CentralLogger::InitializerMixin

    # load earlier than bootstrap.rb initializer loads the default logger.  bootstrap
    # initializer will then skip its own initialization once Rails.logger is defined
    initializer :initialize_central_logger, :before => :initialize_logger do
      app_config = Rails.application.config

      clogger = create_logger(app_config,
        ((app_config.paths['log'] rescue nil) || app_config.paths.log.to_a).first)

      Rails.logger = config.logger = clogger unless clogger.nil?
    end
  end
end

