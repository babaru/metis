class SetClientDiscountDefaults < ActiveRecord::Migration
  def up
    change_column :client_discounts, :website_discount, :decimal, precision: 8, scale: 2, :default => 1
    change_column :client_discounts, :company_discount, :decimal, precision: 8, scale: 2, :default => 1
    change_column :client_discounts, :website_bonus_ratio, :decimal, precision: 8, scale: 2, :default => 0
    change_column :client_discounts, :company_bonus_ratio, :decimal, precision: 8, scale: 2, :default => 0
  end

  def down
    change_column :client_discounts, :website_discount, :decimal, precision: 8, scale: 2
    change_column :client_discounts, :company_discount, :decimal, precision: 8, scale: 2
    change_column :client_discounts, :website_bonus_ratio, :decimal, precision: 8, scale: 2
    change_column :client_discounts, :company_bonus_ratio, :decimal, precision: 8, scale: 2
  end
end
