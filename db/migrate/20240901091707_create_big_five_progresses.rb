class CreateBigFiveProgresses < ActiveRecord::Migration[7.0]
  def change
    create_table :big_five_progresses do |t|
      t.references :user, foreign_key: true
      t.integer :current_question_id
      t.integer :next_question_id
      t.boolean :finished, default: false
      t.timestamps
    end
  end
end
