class AddNameColumnsMasterPlans < ActiveRecord::Migration
  def up
    add_column :master_plans, :project_name, :string
    add_column :master_plans, :client_name, :string
    add_column :master_plans, :created_by_name, :string
  end

  def down
    remove_column :master_plans, :project_name
    remove_column :master_plans, :client_name
    remove_column :master_plans, :created_by_name
  end
end
