class CreateUserPersonalities < ActiveRecord::Migration[7.0]
  def change
    create_table :user_personalities do |t|
      t.references :user, foreign_key: true
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
      t.timestamps
    end
  end
end
