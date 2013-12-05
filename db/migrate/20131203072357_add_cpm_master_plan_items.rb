class AddCpmMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :cpm, :integer
  end

  def down
    remove_column :master_plan_items, :cpm
  end
end
