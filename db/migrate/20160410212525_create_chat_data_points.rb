class CreateChatDataPoints < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_data_points do |t|
      t.string :channel, null: false
      t.string :nick, null: false
      t.date :full_date, null: false
      t.integer :day, null: false, default: 0
      t.integer :hour, null: false, default: 0
      t.integer :line_count, null: false, default: 0
      t.integer :word_count, null: false, default: 0
      t.text :random_quote

      t.timestamps
    end

    add_index :chat_data_points, :full_date
    add_index :chat_data_points, :day
    add_index :chat_data_points, :hour
    add_index :chat_data_points, :nick
    add_index :chat_data_points, :channel
  end
end
