class AddCompanyBonusRatioClientDiscounts < ActiveRecord::Migration
  def up
    add_column :client_discounts, :company_bonus_ratio, :decimal, precision: 8, scale: 2
    change_column :client_discounts, :on_house_rate, :decimal, precision: 8, scale: 2
    rename_column :client_discounts, :on_house_rate, :website_bonus_ratio
    rename_column :client_discounts, :our_discount, :company_discount

    ClientDiscount.all.each do |cd|
      cd.company_bonus_ratio = cd.website_bonus_ratio
      cd.save
    end
  end

  def down
    rename_column :client_discounts, :company_discount, :our_discount
    rename_column :client_discounts, :website_bonus_ratio, :on_house_rate
    change_column :client_discounts, :on_house_rate, :decimal, precision: 8, scale: 1
    remove_column :client_discounts, :company_bonus_ratio
  end
end
