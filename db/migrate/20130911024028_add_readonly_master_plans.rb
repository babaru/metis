class AddReadonlyMasterPlans < ActiveRecord::Migration
  def up
    add_column :master_plans, :is_readonly, :boolean, default: false
  end

  def down
    remove_column :master_plans, :is_readonly
  end
end
