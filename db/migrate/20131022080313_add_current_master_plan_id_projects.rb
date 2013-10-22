class AddCurrentMasterPlanIdProjects < ActiveRecord::Migration
  def up
    add_column :projects, :current_master_plan_id, :integer
    add_index :projects, :current_master_plan_id

    Project.all.each do |project|
      mp = project.master_plans.order('created_at DESC').first
      project.current_master_plan_id = mp.id if mp
      project.save
    end
  end

  def down
    remove_index :projects, :current_master_plan_id
    remove_column :projects, :current_master_plan_id
  end
end
