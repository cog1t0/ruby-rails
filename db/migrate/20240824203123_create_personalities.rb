class CreatePersonalities < ActiveRecord::Migration[7.0]
  def change
    create_table :personalities do |t|
      t.string :code1, null: false
      t.string :code2
      t.string :usagi
      t.text :description
      t.text :keyword
      t.timestamps
    end
  end
end
