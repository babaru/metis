class AddNameColumnsMasterPlans < ActiveRecord::Migration
  def up
    add_column :master_plans, :project_name, :string
    add_column :master_plans, :client_name, :string
    add_column :master_plans, :created_by_name, :string

    MasterPlan.all.each do |item|
      item.project_name = item.project.name
      item.client_name = item.client.name
      item.created_by_name = item.created_by.name
      item.save
    end
  end

  def down
    remove_column :master_plans, :project_name
    remove_column :master_plans, :client_name
    remove_column :master_plans, :created_by_name
  end
end
