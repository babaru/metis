class AddRealityMediumPolicyMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :reality_medium_discount, :decimal, precision: 8, scale: 2, default: 1
    add_column :master_plan_items, :reality_company_discount, :decimal, precision: 8, scale: 2, default: 1
  end

  def down
    remove_column :master_plan_items, :reality_medium_discount
    remove_column :master_plan_items, :reality_company_discount
  end
end
