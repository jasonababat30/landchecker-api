class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.string :title
      t.decimal :price, precision: 12, scale: 2
      t.integer :bedrooms
      t.string :property_type
      t.string :status

      t.timestamps
    end

    add_index :properties, :price
    add_index :properties, :bedrooms
    add_index :properties, :property_type
  end
end
