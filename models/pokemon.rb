class Pokemon < ActiveRecord::Base
  validates :name, :national_dex, :species, presence: true

  def self.lookup(term)
    find_by(national_dex: term.to_i) || find_by(name: term.downcase)
  end

  def name
    self[:name].split(' ').map do |part|
      part[0,1].capitalize + part[1,part.length-1]
    end.join(' ')
  end

  def response
    "[#{national_dex}] (#{types.join(', ')}) #{name}: The #{species} Pokémon. #{descriptions.sample}"
  end
end
