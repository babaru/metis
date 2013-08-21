class AddClientAndProjectMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :client_id, :integer
    add_column :master_plan_items, :project_id, :integer
    add_index :master_plan_items, :client_id
    add_index :master_plan_items, :project_id
    MasterPlanItem.transaction do
      MasterPlan.all.each do |master_plan|
        master_plan.items.each do |item|
          item.project_id = master_plan.project_id
          item.client_id = master_plan.client_id
          item.save!
        end
      end
    end
  end

  def down
    remove_column :master_plan_items, :client_id
    remove_column :master_plan_items, :project_id
    remove_index :master_plan_items, :client_id
    remove_index :master_plan_items, :project_id
  end
end
