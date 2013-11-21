class AddLeadsColumnMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :leads, :integer
    remove_column :master_plan_items, :est_cpm
    remove_column :master_plan_items, :cpc
  end

  def down
    remove_column :master_plan_items, :leads
    add_column :master_plan_items, :est_cpm, :integer
    add_column :master_plan_items, :cpc, :integer
  end
end
