class ModifyNameColumnsMasterPlanItems < ActiveRecord::Migration
  def up
    rename_column :master_plan_items, :position_name, :spot_name
    add_column :master_plan_items, :client_name, :string
    add_column :master_plan_items, :project_name, :string
    add_column :master_plan_items, :master_plan_name, :string
  end

  def down
    rename_column :master_plan_items, :spot_name, :position_name
    remove_column :master_plan_items, :project_name
    remove_column :master_plan_items, :client_name
    remove_column :master_plan_items, :master_plan_name
  end
end
