class MathPlugin
  include Cinch::Plugin

  match(/\Amath ([\(\)\d\+\-*^% \/\.]+)\z/, strip_colors: true)

  def execute(m, math)
    return if math.size > 50
    m.reply eval(math)
  rescue => e
    puts e.message
  end
end
