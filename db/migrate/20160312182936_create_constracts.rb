class CreateConstracts < ActiveRecord::Migration
  def change
    create_table :constracts do |t|
      t.string :tour_code
      t.string :customer_id_number
      t.string :company_name
      t.string :company_phone
      t.string :company_address
      t.integer :booking_tickets
      t.integer :total_money

      t.timestamps null: false
    end
  end
end
