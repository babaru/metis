class AddRebateCompanyPolicies < ActiveRecord::Migration
  def up
    add_column :company_policies, :rebate, :decimal, precision: 8, scale: 4
  end

  def down
    remove_column :company_policies, :rebate
  end
end
