class AddDiscountColumnsMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :website_discount, :decimal, precision: 8, scale: 2, default: 1
    add_column :master_plan_items, :company_discount, :decimal, precision: 8, scale: 2, default: 1
    add_column :master_plan_items, :website_bonus_ratio, :decimal, precision: 8, scale: 2, default: 0
    add_column :master_plan_items, :company_bonus_ratio, :decimal, precision: 8, scale: 2, default: 0
    remove_column :master_plan_items, :discount
  end

  def down
    remove_column :master_plan_items, :website_discount
    remove_column :master_plan_items, :company_discount
    remove_column :master_plan_items, :website_bonus_ratio
    remove_column :master_plan_items, :company_bonus_ratio
    add_column :master_plan_items, :discount, :decimal, precision: 8, scale: 2
  end
end
