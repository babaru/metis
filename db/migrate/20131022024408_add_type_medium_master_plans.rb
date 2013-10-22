class AddTypeMediumMasterPlans < ActiveRecord::Migration
  def up
    add_column :medium_master_plans, :type, :string
  end

  def down
    remove_column :medium_master_plans, :type
  end
end
