class AddMoreDiscountColumnsClientDiscounts < ActiveRecord::Migration
  def up
    remove_column :client_discounts, :discount
    add_column :client_discounts, :website_discount, :decimal, precision: 8, scale: 2
    add_column :client_discounts, :our_discount, :decimal, precision: 8, scale: 2
    add_column :client_discounts, :on_house_rate, :decimal, precision: 8, scale: 1
  end

  def down
    add_column :client_discounts, :discount, :decimal, precision: 8, scale: 2
    remove_column :client_discounts, :website_discount
    remove_column :client_discounts, :our_discount
    remove_column :client_discounts, :on_house_rate
  end
end
