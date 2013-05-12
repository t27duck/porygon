class Sayings
  def invoke(data)
    message = data[:message]
    messages.each do |reg, value|
      return value if (message =~ reg) != nil
    end
    if (rand(3) == 1 && data[:nick].downcase != "porygon" && (message =~ /^.*porygon.*$/i) != nil)
      return "#{bot_name}?"
    end
    nil
  end

  private #####################################################################

  def messages
    {
      /^porygon.{0,2}make me a (sandwich|sammich)$/i => "Make one yourself!", 
      /^porygon.{0,2}sudo make me a (sandwich|sammich)$/i => "Ok.", 
      /^porygon.{0,2}what are the rules\?$/i => "[1] A robot may not injure a human being or, through inaction, allow a human being to come to harm. [2] A robot must obey any orders given to it by human beings, except where such orders would conflict with the First Law. [3] A robot must protect its own existence as long as such protection does not conflict with the First or Second Law.",
      /^porygon.{0,2}what is The Answer to the Ultimate Question of Life, the Universe, and Everything\?$/i => "42",
      /^i want to rock and roll all night$/i => "and party every day",
      /^%(song|chatroomsong|sing)$/i => "Let's gather 'round the chatroom and sing our chatroom song. Our C-H-A-T-R-O-O-M S-O-N-G song. And if you don't think that we can sing it faster then you're wrong. But it'll help if you just sing along...",
      /^(hi|hello|sup|what's up|hiya|hey|wb|welcome back|it's|right|how you doin|ok|<3).*porygon.*$/i => "#{bot_name}! ^_^",
      /^%legend$/i => "Disturb not the harmony of Fire, Ice, or Lightning lest these three Titans wreck destruction upon the world in which they clash. Though the water's Great Guardian shall arise to quell the fighting alone its song will fail. Thus the Earth shall turn to ash. O, Chosen One, into thine hands bring together all three. Their treasures combined tame the beast of the sea."
    }
  end

  def bot_name
    case rand(5)
    when 0
      "Pooooooorygon"
    when 1
      "Pory-Porygon"
    when 2
      "Pory-Pory Porygon"
    else
      "Porygon"
    end
  end
end
