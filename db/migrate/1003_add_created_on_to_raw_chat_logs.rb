class AddCreatedOnToRawChatLogs < ActiveRecord::Migration
  def up
    add_column :raw_chat_logs, :created_on, :date
    RawChatLog.find_each do |l|
      l.update_column(:created_on, l.created_at)
    end
    change_column :raw_chat_logs, :created_on, :date, null: false

    add_index :raw_chat_logs, :created_on
  end

  def down
    remove_index :raw_chat_logs, :created_on
    remove_column :raw_chat_logs, :created_on, :date
  end
end
