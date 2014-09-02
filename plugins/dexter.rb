require "data_mapper"

DataMapper.setup(:pokemon, "sqlite://#{Dir.pwd}/db/pokemon.db")
class Dexter
  include Cinch::Plugin

  match /dexter (\w+)/i, :strip_colors => true
  match /pokedex (\w+)/i, :strip_colors => true

  def execute(m, poke_id)
    m.reply Pokemon.lookup(poke_id)
  end
end

class Pokemon
  include DataMapper::Resource
  def self.default_repository_name
    :pokemon
  end

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
  def self.default_repository_name
    :pokemon
  end

  property :id, Serial, :key => true
  property :description, Text
  belongs_to :pokemon

  def to_s
    description
  end
end

class PokemonType
  include DataMapper::Resource
  def self.default_repository_name
    :pokemon
  end

  property :id, Serial, :key => true
  property :type_name, Text
  belongs_to :pokemon

  def to_s
    type_name
  end
end
