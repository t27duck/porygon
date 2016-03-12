require 'active_record'

ActiveRecord::Base.establish_connection YAML::load_file('./config/database.yml')

class Pokemon < ActiveRecord::Base
  def self.lookup(term)
    find_by(national_dex: term.to_i) || find_by(name: term.downcase)
  end

  def name
    self[:name][0,1].capitalize + self[:name][1,self[:name].length-1]
  end

  def response
    "[#{national_dex}] (#{types.join(', ')}) #{name}: The #{species} Pokémon. #{descriptions.sample}"
  end
end

class Dexter
  include Cinch::Plugin

  match /dexter (\w+)/i, strip_colors: true
  match /pokedex (\w+)/i, strip_colors: true

  def execute(m, poke_id)
    pokemon = Pokemon.lookup(poke_id.strip)
    if pokemon
      m.reply pokemon.response
    else
      m.reply 'Pokémon not found'
    end
  end
end
