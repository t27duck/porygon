class Sayings
  include Cinch::Plugin

  def self.messages
    {
      /^porygon.{0,2}make me a (sandwich|sammich)$/i => "Make one yourself!",
      /^porygon.{0,2}sudo make me a (sandwich|sammich)$/i => "Ok.",
      /^porygon.{0,2}what are the rules\?$/i => "[1] A robot may not injure a human being or, through inaction, allow a human being to come to harm. [2] A robot must obey any orders given to it by human beings, except where such orders would conflict with the First Law. [3] A robot must protect its own existence as long as such protection does not conflict with the First or Second Law.",
      /^porygon.{0,2}what is The Answer to the Ultimate Question of Life, the Universe, and Everything\?$/i => "42",
      /^i want to rock and roll all night$/i => "and party every day",
      /^video.*games.?$/i => "Serious business.",
      /^guys!?$/i => "... and dolls... We're just a bunch of crazy guys and dolls...",
      /^(hi|hello|sup|what's up|hiya|hey|wb|welcome back|it's|right|how you doin|ok|<3).*porygon.*$/i => "Porygon! ^_^"
    }
  end

  def self.messages_with_prefix
    {
      /(song|chatroomsong|sing)$/i => "Let's gather 'round the chatroom and sing our chatroom song. Our C-H-A-T-R-O-O-M S-O-N-G song. And if you don't think that we can sing it faster then you're wrong. But it'll help if you just sing along...",
      /legend$/i => "Disturb not the harmony of Fire, Ice, or Lightning lest these three Titans wreck destruction upon the world in which they clash. Though the water's Great Guardian shall arise to quell the fighting alone its song will fail. Thus the Earth shall turn to ash. O, Chosen One, into thine hands bring together all three. Their treasures combined tame the beast of the sea."
    }
  end

  def self.make_method(name, reg, saying, use_prefix)
    define_method(name) do |m|
      return if m.user.nick.downcase == m.bot.nick.downcase
      m.reply saying
    end
    match reg, :use_prefix => use_prefix, :strip_colors => true, :method => name
  end

  messages.each_with_index do |(reg, saying), index|
    make_method("saying_#{index}", reg, saying, false)
  end

  messages_with_prefix.each_with_index do |(reg, saying), index|
    make_method("saying_with_prefix_#{index}", reg, saying, true)
  end

  match /lol/i, :use_prefix => false, :strip_colors => true, :method => :cdarr

  def cdarr(m)
    return unless m.user.nick.downcase.include?("cdarr")
    m.reply "lolcdarr <3"
  end
end
