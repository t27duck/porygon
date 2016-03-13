class Dexter
  include Cinch::Plugin

  match /dexter ([\w \.-]+)/i, strip_colors: true
  match /pokedex ([\w \.-]+)/i, strip_colors: true

  def execute(m, poke_id)
    pokemon = Pokemon.lookup(poke_id.strip)
    if pokemon
      m.reply pokemon.response
    else
      m.reply 'Pokémon not found'
    end
  end
end
