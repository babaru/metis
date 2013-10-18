class RemoveCpmDiscountMediumPolicies < ActiveRecord::Migration
  def up
    remove_column :medium_policies, :medium_cpm_discount
    remove_column :medium_policies, :company_cpm_discount
  end

  def down
    add_column :medium_policies, :medium_cpm_discount, :decimal, precision: 8, scale: 2, default: 1
    add_column :medium_policies, :company_cpm_discount, :decimal, precision: 8, scale: 2, default: 1
  end
end
