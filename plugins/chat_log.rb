require "logger"
class ChatLog
  include Cinch::Plugin

  def initialize(*args)
    super
    @loggers = {}
    bot.config.channels.each do |c|
      create_logger(c)
    end
  end

  listen_to :message, :method => :process_message, :strip_colors => true
  listen_to :leaving, :method => :process_leaving, :strip_colors => true
  listen_to :join, :method => :process_join, :strip_colors => true

  def process_message(m)
    if m.channel?
      if m.action?
        log_message(m.channel.name, "[#{Time.now.strftime("%H:%M:%S")}] *#{m.user.name} #{m.message.gsub(/ACTION /,"")}")
      else
        log_message(m.channel.name, "[#{Time.now.strftime("%H:%M:%S")}] #{m.user.name}: #{m.message}")
      end
    end
  end

  def process_leaving(m, user)
    if m.channel?
      log_message(m.channel.name, "[#{Time.now.strftime("%H:%M:%S")}] PART: #{m.user.name}")
    end
  end

  def process_join(m)
    log_message(m.channel.name, "[#{Time.now.strftime("%H:%M:%S")}] JOIN: #{m.user.name}")
  end

  private #####################################################################

  def today
    Time.now.strftime("%Y-%m-%d")
  end

  def create_logger(channel)
    new_today = today
    @loggers[channel] = {:today => new_today, :logger => Logger.new("chatlogs/#{new_today}-#{channel}.log") }
    @loggers[channel][:logger].formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end
  end

  def log_message(channel, message)
    create_logger(channel) if @loggers[channel].nil? || today != @loggers[channel][:today]
    @loggers[channel][:logger].info message
  end

end
