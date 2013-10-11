class ModifyCountDaysColumnMasterPlanItems < ActiveRecord::Migration
  def up
    remove_column :master_plan_items, :days
    change_column :master_plan_items, :count, :integer, default: 0
  end

  def down
    add_column :master_plan_items, :days, :integer
    change_column :master_plan_items, :count, :integer
  end
end
