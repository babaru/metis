class AddCompanyPolicyColumnsMediumMasterPlans < ActiveRecord::Migration
  def up
    add_column :medium_master_plans, :regular_medium_rebate, :decimal, precision: 8, scale: 4
    add_column :medium_master_plans, :extra_medium_rebate, :decimal, precision: 8, scale: 4
  end

  def down
    remove_column :medium_master_plans, :regular_medium_rebate
    remove_column :medium_master_plans, :extra_medium_rebate
  end
end
