class CreateSayingResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :saying_responses do |t|
      t.integer :saying_id, null: false
      t.text :content,      null: false

      t.timestamps
    end

    add_index :saying_responses, :saying_id
    add_foreign_key :saying_responses, :sayings
  end
end
