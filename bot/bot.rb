environment = ENV["BOT_ENV"] || "development"

require "bundler/setup"
require "yaml"
require "erb"

Bundler.require(:default, :bot)

dbconfig = ERB.new(File.open("./config/database.yml"){ |f| f.read }).result
ActiveRecord::Base.establish_connection YAML::load(dbconfig)[environment]

CONFIG = YAML::load_file(ENV["PORYGON_CONFIG"] || "./bot/config.yml")

Dir.glob('./bot/{initializers}/*.rb').each { |file| require file }
Dir.glob('./bot/{plugins}/*.rb').each { |file| require file }

require "./app/models/application_record.rb"
require "./app/models/nick_whitelist.rb"
require "./app/models/pokemon.rb"
require "./app/models/raw_chat_log.rb"
require "./app/models/saying.rb"
require "./app/models/saying_response.rb"
require "./app/models/seen_activity.rb"

plugin_list = [Sayings, Twitter, Dexter, ChatLog, Site, Weather, Seen, MathPlugin]
plugin_list << Cinch::Plugins::Identify if CONFIG["irc"]["nickserv_password"]
plugin_list << Youtube if CONFIG["youtube"]

bot = Cinch::Bot.new do
  configure do |c|
    c.server          = CONFIG["irc"]["server"]
    c.channels        = CONFIG["irc"]["channels"]
    c.nick            = CONFIG["irc"]["nick"]
    c.plugins.plugins = plugin_list

    if plugin_list.include?(Cinch::Plugins::Identify)
      c.plugins.options[Cinch::Plugins::Identify] = {
        password: CONFIG["irc"]["nickserv_password"],
        type:     :nickserv
      }
    end
  end
end

bot.start
