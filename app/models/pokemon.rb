class Pokemon < ApplicationRecord
  validates :name, :national_dex, :species, presence: true

  def self.lookup(term)
    find_by(national_dex: term.to_i) || find_by(name: term.downcase)
  end

  def response
    [].tap do |part|
      part << "[#{national_dex}]"
      part << "(#{types.join(', ')})"
      part << "#{name.titlecase}: The #{species} Pokémon."
      part << descriptions.sample
    end.join(' ')
  end
end
