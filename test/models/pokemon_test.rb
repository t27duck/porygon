require 'test_helper'

class PokemonTest < ActiveSupport::TestCase
  test '.lookup finds pokemon by national dex number' do
    pokemon = Pokemon.first

    result = Pokemon.lookup(pokemon.national_dex)
    assert_equal result, pokemon
  end

  test '.lookup finds pokemon by name' do
    pokemon = Pokemon.first

    result = Pokemon.lookup(pokemon.name)
    assert_equal result, pokemon

    result = Pokemon.lookup(pokemon.name.upcase)
    assert_equal result, pokemon

    result = Pokemon.lookup(pokemon.name.titlecase)
    assert_equal result, pokemon
  end

  test '#response returns a string' do
    pokemon = Pokemon.first
    assert pokemon.response.is_a?(String), '#response is not a string'
  end
end
