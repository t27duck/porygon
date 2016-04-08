class LowerCaseNicks < ActiveRecord::Migration[5.0]
  def up
    RawChatLog.connection.execute "UPDATE #{RawChatLog.quoted_table_name} SET nick = lower(nick)"
  end

  def down
    # noop
  end
end
