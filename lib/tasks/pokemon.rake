desc 'Loads Pokemon data from db/pokemon_seed.yml'
task pokemonseed: :environment do
  Pokemon.transaction do
    YAML.load(File.read("#{Rails.root}/db/pokemon_seed.yml")).each do |national_id, data|
      pokemon = Pokemon.find_or_initialize_by(national_dex: national_id.to_i)
      pokemon.attributes = data
      pokemon.save!
    end
  end
end
