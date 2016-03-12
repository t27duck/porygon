require "cinch"
require "cinch/plugins/identify"
require "yaml"

require 'active_record'
ActiveRecord::Base.establish_connection YAML::load_file('./config/database.yml')

CONFIG = YAML::load_file(ENV["PORYGON_CONFIG"] || "./config/config.yml")

Dir.glob('./{plugins}/*.rb').each { |file| require file }
Dir.glob('./{models}/*.rb').each { |file| require file }

plugin_list = [Sayings, Twitter, Dexter, ChatLog, GoNintendo, GoingSony, Weather]
plugin_list << Cinch::Plugins::Identify if CONFIG["irc"]["nickserv_password"]

bot = Cinch::Bot.new do
  configure do |c|
    c.server = CONFIG["irc"]["server"]
    c.channels = CONFIG["irc"]["channels"]
    c.nick = CONFIG["irc"]["nick"]
    c.plugins.plugins = plugin_list

    if plugin_list.include?(Cinch::Plugins::Identify)
      c.plugins.options[Cinch::Plugins::Identify] = {
        :password => CONFIG["irc"]["nickserv_password"],
        :type     => :nickserv
      }
    end

  end
end

bot.start
