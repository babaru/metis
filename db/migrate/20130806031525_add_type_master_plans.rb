class AddTypeMasterPlans < ActiveRecord::Migration
  def up
    add_column :master_plans, :type, :string
    add_column :master_plans, :discount, :decimal, precision: 8, scale: 2
  end

  def down
    remove_column :master_plans, :discount
    remove_column :master_plans, :type
  end
end
