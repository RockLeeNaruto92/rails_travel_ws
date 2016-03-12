class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.string :code
      t.string :place_code
      t.date :start_date
      t.integer :tickets
      t.integer :available_tickets
      t.integer :cost
      t.text :description

      t.timestamps null: false
    end
  end
end
