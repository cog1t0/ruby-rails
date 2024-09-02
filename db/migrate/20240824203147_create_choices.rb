class CreateChoices < ActiveRecord::Migration[7.0]
  def change
    create_table :choices do |t|
      t.references :question, foreign_key: true
      t.text :text
      t.integer :p_code_10, default: 0
      t.integer :p_code_11, default: 0
      t.integer :p_code_20, default: 0
      t.integer :p_code_21, default: 0
      t.integer :p_code_30, default: 0
      t.integer :p_code_31, default: 0
      t.integer :p_code_40, default: 0
      t.integer :p_code_41, default: 0
      t.integer :p_code_50, default: 0
      t.integer :p_code_51, default: 0
      t.text :memo
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
