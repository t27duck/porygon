# encoding: UTF-8

require "bundler/setup"
require 'data_mapper'
require 'rufus/scheduler'

load "config.rb"
Settings.load!

scheduler = Rufus::Scheduler.start_new

DataMapper.setup(:default, Settings.database['connection_string'])

load "bot.rb"
load "pokemon.rb"
load "sayings.rb"
load "chat_log.rb"
load "twitter.rb"
load "gn_story.rb"
load "gn_feed.rb"

gn_feed_checker = GnFeed.new

# The main program
# If we get an exception, then print it out and keep going (we do NOT want
# to disconnect unexpectedly!)
irc = IRC.new(Settings.irc['host'], Settings.irc['port'], Settings.irc['nick'], Settings.irc['room'], Settings.irc['nickserv_password'])

irc.bot_modules << Dexter.new
irc.bot_modules << Sayings.new
irc.bot_modules << ChatLog.new
irc.bot_modules << Twitter.new
irc.bot_modules << GnStory.new

irc.connect

scheduler.every '10m' do
  result = gn_feed_checker.check
  result.each do |m|
    irc.message_channel(m)
  end
end

begin
  irc.main_loop()
rescue Interrupt
rescue Exception => detail
  puts detail.message()
  print detail.backtrace.join("\n")
  retry
end



