class ChangeMasterPlanItemColumns < ActiveRecord::Migration
  def up
    change_column :master_plan_items, :unit_rate_card, :decimal, precision: 10, scale: 3, default: nil
    change_column :master_plan_items, :unit_rate_card_unit_type, :integer, default: nil
    change_column :master_plan_items, :original_medium_discount, :decimal, precision: 8, scale: 2, default: nil
    change_column :master_plan_items, :original_company_discount, :decimal, precision: 8, scale: 2, default: nil
    change_column :master_plan_items, :reality_medium_discount, :decimal, precision: 8, scale: 2, default: nil
    change_column :master_plan_items, :reality_company_discount, :decimal, precision: 8, scale: 2, default: nil
  end

  def down
    change_column :master_plan_items, :unit_rate_card, :decimal, precision: 10, scale: 3, default: 0
    change_column :master_plan_items, :unit_rate_card_unit_type, :integer, default: 0
    change_column :master_plan_items, :original_medium_discount, :decimal, precision: 8, scale: 2, default: 1
    change_column :master_plan_items, :original_company_discount, :decimal, precision: 8, scale: 2, default: 1
    change_column :master_plan_items, :reality_medium_discount, :decimal, precision: 8, scale: 2, default: 1
    change_column :master_plan_items, :reality_company_discount, :decimal, precision: 8, scale: 2, default: 1
  end
end
