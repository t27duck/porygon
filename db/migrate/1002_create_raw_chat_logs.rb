class CreateRawChatLogs < ActiveRecord::Migration[4.2]
  def change
    create_table :raw_chat_logs do |t|
      t.string :channel,  null: false
      t.integer :event,   null: false
      t.string :nick,     null: false
      t.string :host,     null: false
      t.text :message,    null: false

      t.boolean :parsed,  null: false, default: false

      t.timestamps null: false
    end

    add_index :raw_chat_logs, :channel
    add_index :raw_chat_logs, :event
    add_index :raw_chat_logs, :created_at, order: {created_at: :asc}
  end
end
