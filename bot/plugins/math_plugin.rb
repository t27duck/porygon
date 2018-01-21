class MathPlugin
  include Cinch::Plugin

  match(/math ([\(\)\d\+\-*^% \/\.]+)\z/, strip_colors: true, user_prefix: true)

  def execute(m, math)
    return if math.size > 50
    m.reply eval(math)
  rescue => e
    puts e.message
  end
end
