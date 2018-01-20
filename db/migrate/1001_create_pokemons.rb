class CreatePokemons < ActiveRecord::Migration[4.2]
  def change
    create_table :pokemons do |t|
      t.string :name,           null: false
      t.integer :national_dex,  null: false
      t.string :types,          null: false, array: true, default: []
      t.string :species,        null: false
      t.text :descriptions,     null: false, array: true, default: []

      t.timestamps              null: false
    end

    add_index :pokemons, :national_dex, unique: true
  end
end
