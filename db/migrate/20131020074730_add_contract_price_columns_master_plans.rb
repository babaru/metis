class AddContractPriceColumnsMasterPlans < ActiveRecord::Migration
  def up
    add_column :master_plans, :reality_medium_net_cost, :decimal, precision: 10, scale: 3, default: 0
    add_column :master_plans, :reality_company_net_cost, :decimal, precision: 10, scale: 3, default: 0
  end

  def down
    remove_column :master_plans, :reality_medium_net_cost
    remove_column :master_plans, :reality_company_net_cost
  end
end
