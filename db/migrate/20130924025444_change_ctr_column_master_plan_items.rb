class ChangeCtrColumnMasterPlanItems < ActiveRecord::Migration
  def up
    change_column :master_plan_items, :est_ctr, :decimal, precision: 8, scale: 4
    change_column :master_plan_items, :discount, :decimal, precision: 8, scale: 2
  end

  def down
    change_column :master_plan_items, :est_ctr, :integer
    change_column :master_plan_items, :discount, :decimal
  end
end
