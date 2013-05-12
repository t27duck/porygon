require "logger"
class ChatLog

  def initialize(setup={})
    @directory = setup.fetch(:directory, "logs")
    @file = today
    create_logger
  end

  def invoke(data)
    log_message construct_message(data)
    nil
  end

  private #####################################################################

  def today
    Time.now.strftime("%Y-%m-%d")
  end

  def create_logger
    @logger = Logger.new("#{@directory}/#{@file}.log")
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end
  end

  def construct_message(data)
    "["+Time.now.strftime("%H:%M:%S")+"] #{data[:nick]}: #{data[:message]}"
  end

  def log_message(message)
    new_logger if today != @file
    @logger.info message
  end

  def new_logger
    @file = today
    create_logger
  end

end
