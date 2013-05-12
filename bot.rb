# encoding: UTF-8
class IRC
  attr_accessor :bot_modules
  
  def initialize(server, port, nick, channel, nickserv_password=nil)
    @server             = server
    @port               = port
    @nick               = nick
    @channel            = channel
    @nickserv_password  = nickserv_password
    @bot_modules = []
  end

  def send(s)
    # Send a message to the irc server and print it to the screen
    puts "--> #{s}"
    @irc.send "#{s}\n", 0 
  end

  def message_channel(message)
    send "PRIVMSG #{@channel} :#{message}"
  end

  def connect
    @irc = TCPSocket.open(@server, @port)
    send "NICK #{@nick}"
    send "USER #{@nick} #{@nick} #{@nick} :#{@nick}"
    send "NS IDENTIFY #{@nickserv_password}" if @nickserv_password
    send "JOIN #{@channel}"
  end

  def handle_server_input(s, r=nil)
    s = s.scan(/[[:print:]]/).join
    case s.strip
    when /^PING :(.+)$/i
      puts "[ Server ping ]"
      send "PONG :#{$1}"
    when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:[\001]PING (.+)[\001]$/i
      puts "[ CTCP PING from #{$1}!#{$2}@#{$3} ]"
      send "NOTICE #{$1} :\001PING #{$4}\001"
    when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:[\001]VERSION[\001]$/i
      puts "[ CTCP VERSION from #{$1}!#{$2}@#{$3} ]"
      send "NOTICE #{$1} :\001VERSION Ruby-irc v0.042\001"
    else
      process(s)
    end
  end

  def process(message)
    data = parse_string(message)
    return if data[:nick] == 'LagServ' || data[:channel] != @channel.downcase

    if data[:action] == "JOIN"
      message_channel("Wild #{data[:nick]} appeared!") if rand(30) == 1
    end
      
    bot_modules.each do |bot_module|
      response = bot_module.invoke(data)
      message_channel(response) unless response.nil?
    end
  end

  def parse_string(s)
    data = {}
    s.slice!(0) # Removes leading :
    data_array = s.gsub("\t", " ").split(' ')

    nick_and_mask = data_array.shift
    nick_and_mask = nick_and_mask.split("!")

    data[:nick] = nick_and_mask[0]
    data[:host] = nick_and_mask[1]
    data[:action] = data_array.shift

    case data[:action]
    when "JOIN"
      data[:channel] = data_array.shift.downcase
      data[:channel].slice!(0)
      data[:message] = "[JOINED CHANNEL]"
    when "PRIVMSG"
      data[:channel] = data_array.shift.downcase
      data[:message] = data_array.join(' ')
      data[:message].slice!(0)
      message_array = data[:message].split(' ')
      if message_array[0] == "ACTION"
        data[:action] = "ACTION"
        message_array[0] = '*'
        data[:message] = message_array.join(' ')
      end
    when "NICK"
      data[:channel] = @channel.downcase
      new_nick = data_array.shift
      new_nick.slice!(0)
      data[:new_nick] = new_nick
      data[:message] = "[NICK CHANGE: #{new_nick}]"
    when "QUIT"
      data[:channel] = @channel.downcase
      quit_message = data_array.join(' ') #.shift
      quit_message.slice!(0)
      data[:message] = "[QUIT CHANNEL: #{quit_message}]"
    when "PART"
      data[:channel] = data_array.shift.downcase
      part_message = data_array.join(' ') #.shift
      part_message.slice!(0)
      data[:message] = "[PART CHANNEL: #{part_message}]"
    when "KICK"
      data[:channel] = data_array.shift.downcase
      kicked_nick = data_array.shift
      kick_message = data_array.join(' ') #.shift
      kick_message.slice!(0)
      data[:message] = "[KICK: #{kicked_nick} (#{kick_message})]"
    else
      data[:channel] = "NA"
      data[:message] = data_array.join(' ')
    end
    data
  end

  def main_loop
    # Just keep on truckin' until we disconnect
    while true
      ready = select([@irc, $stdin], nil, nil, nil)
      next if !ready
      for s in ready[0]
        if s == $stdin then
          return if $stdin.eof
          s = $stdin.gets
          send s
        elsif s == @irc then
          return if @irc.eof
          s = @irc.gets
          handle_server_input(s)
        end
      end
    end
  end
end

