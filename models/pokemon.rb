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
