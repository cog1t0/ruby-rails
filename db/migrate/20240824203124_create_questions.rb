class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.datetime :deleted_at
      t.text :memo
      t.timestamps
    end
  end
end
