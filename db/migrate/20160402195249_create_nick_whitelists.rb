class CreateNickWhitelists < ActiveRecord::Migration[5.0]
  def change
    create_table :nick_whitelists do |t|
      t.string :nick, null: false

      t.timestamps
    end

    add_index :nick_whitelists, :nick, unique: true
  end
end
