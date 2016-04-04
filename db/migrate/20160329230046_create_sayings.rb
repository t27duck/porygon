class CreateSayings < ActiveRecord::Migration[5.0]
  def change
    create_table :sayings do |t|
      t.string :name,                 null: false
      t.string :pattern,              null: false
      t.integer :trigger_percentage,  null: false, default: 100
      t.boolean :enabled,             null: false, default: true

      t.timestamps
    end

    add_index :sayings, :name, unique: true
    add_index :sayings, :pattern, unique: true
  end
end
