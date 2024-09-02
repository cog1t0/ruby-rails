class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :line_id, null: false
      t.string :stripe_customer_id
      t.string :stripe_subscription_id
      t.boolean :subscription_flg, default: false
      t.date :expiration_date
      t.datetime :deleted_at
      
      t.timestamps
    end
  end
end
