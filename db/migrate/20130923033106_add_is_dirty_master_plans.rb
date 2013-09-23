class AddIsDirtyMasterPlans < ActiveRecord::Migration
  def up
    add_column :master_plans, :is_dirty, :boolean, default: true
    remove_column :master_plans, :version
  end

  def down
    remove_column :master_plans, :is_dirty
    add_column :master_plans, :version, :integer, default: 1
  end
end
