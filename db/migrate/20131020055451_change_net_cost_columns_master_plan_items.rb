class ChangeNetCostColumnsMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :reality_company_net_cost, :decimal, precision: 20, scale: 3
    add_column :master_plan_items, :reality_medium_net_cost, :decimal, precision: 20, scale: 3

    remove_column :master_plan_items, :net_cost
  end

  def down
    remove_column :master_plan_items, :reality_company_net_cost
    remove_column :master_plan_items, :reality_medium_net_cost

    add_column :master_plan_items, :net_cost, :decimal, precision: 10, scale: 3, default: 0
  end
end
