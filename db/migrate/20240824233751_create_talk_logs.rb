class CreateTalkLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :talk_logs do |t|
      t.references :user, foreign_key: true
      t.integer :role, null: false
      t.text :content
      t.timestamps
    end
  end
end
