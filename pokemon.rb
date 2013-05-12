class Dexter
  def invoke(data)
    message = data[:message]
    return nil if (message =~ /^%(dexter|pokedex)\s\w+$/i) == nil
    search_term = message.split(" ")[1]
    Pokemon.lookup(search_term)
  end
end


class Pokemon
  include DataMapper::Resource

  property :id, Integer, :key => true
  property :slug, String
  property :name, String
  property :species, String

  has n, :pokemon_descriptions
  has n, :pokemon_types

  def self.lookup(search_term)
    result = all(:id => search_term.to_i) 
    result = all(:slug => search_term.downcase) if result.empty?

    return "Pokemon not found" if result.empty?
    
    pokemon = result[0]
    pokemon.full_string
  end

  def full_string
    "[#{id}] #{name}#{type_string}: The #{species}. #{description_string}" 
  end

  def type_string
    unless pokemon_types.empty?
      " (#{pokemon_types.join(", ")})"
    end
  end

  def description_string
    unless pokemon_descriptions.empty?
      pokemon_descriptions.sample.to_s
    end
  end
end

class PokemonDescription
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :description, Text
  belongs_to :pokemon

  def to_s
    description
  end
end

class PokemonType
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :type_name, Text
  belongs_to :pokemon

  def to_s
    type_name
  end
end
