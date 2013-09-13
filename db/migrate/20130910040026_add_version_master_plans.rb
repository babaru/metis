class AddVersionMasterPlans < ActiveRecord::Migration
  def up
    add_column :master_plans, :version, :integer, default: 1
  end

  def down
    remove_column :master_plans, :version
  end
end
