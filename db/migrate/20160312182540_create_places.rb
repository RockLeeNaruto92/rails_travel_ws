class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :code
      t.string :name
      t.string :city
      t.string :country
      t.string :address
      t.text :services
      t.text :description

      t.timestamps null: false
    end
  end
end
