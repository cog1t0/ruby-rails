class CreateUserPersonalities < ActiveRecord::Migration[7.0]
  def change
    create_table :user_personalities do |t|
      t.references :user, foreign_key: true
      t.integer :p_code_10
      t.integer :p_code_11
      t.integer :p_code_20
      t.integer :p_code_21
      t.integer :p_code_30
      t.integer :p_code_31
      t.integer :p_code_40
      t.integer :p_code_41
      t.integer :p_code_50
      t.integer :p_code_51
      t.text :memo
      t.timestamps
    end
  end
end
