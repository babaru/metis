class AddClientMasterPlan < ActiveRecord::Migration
  def up
    add_column :master_plans, :client_id, :integer
    add_index :master_plans, :client_id
    MasterPlan.transaction do
      Project.all.each do |project|
        project.master_plans.each do |master_plan|
          master_plan.client_id = project.client_id
          master_plan.save!
        end
      end
    end
  end

  def down
    remove_column :master_plans, :client_id
    remove_index :master_plans, :client_id
  end
end
