class CreateSeenActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :seen_activities do |t|
      t.string :channel, null: false
      t.string :nick, null: false
      t.text :message

      t.timestamps
    end

    add_index :seen_activities, [:channel, :nick], unique: true
  end
end
