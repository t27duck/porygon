class Sayings
  include Cinch::Plugin

  def initialize(*args)
    load_sayings
    super
  end

  listen_to :message, method: :process_message, strip_colors: true
  match /reload\z/, method: :reload_sayings, strip_colors: true, user_prefix: true

  private ######################################################################

  def load_sayings
    @sayings = {}.tap do |sayings|
      Saying.enabled.includes(:responses).each do |saying|
        next if saying.responses.blank?
        regexp = Regexp.new(saying.pattern, Regexp::IGNORECASE)
        sayings[regexp] = saying
      end
    end
  end

  def reload_sayings(m)
    return unless NickWhitelist.includes?(m.user.nick.downcase)
    load_sayings
    m.reply "Sayings reloaded!"
  end

  def process_message(m)
    @sayings.each do |regexp, saying|
      if m.message.strip.match(regexp) && rand(100) < saying.trigger_percentage
        m.reply saying.responses.sample.content
        break
      end
    end
  end
end
