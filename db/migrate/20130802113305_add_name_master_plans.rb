class AddNameMasterPlans < ActiveRecord::Migration
  def up
    add_column :master_plans, :name, :string
  end

  def down
    remove_column :master_plans, :name
  end
end
