class RemoveDiscountMasterPlans < ActiveRecord::Migration
  def up
    remove_column :master_plans, :discount
  end

  def down
    add_column :master_plans, :discount, :decimal, precision: 8, scale: 2, default: 1
  end
end
