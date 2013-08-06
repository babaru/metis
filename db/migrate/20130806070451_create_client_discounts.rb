class CreateClientDiscounts < ActiveRecord::Migration
  def change
    create_table :client_discounts do |t|
      t.references :client
      t.references :website
      t.decimal :discount, precision: 8, scale: 2

      t.timestamps
    end
    add_index :client_discounts, :client_id
    add_index :client_discounts, :website_id
  end
end
