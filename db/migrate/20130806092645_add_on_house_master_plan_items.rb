class AddOnHouseMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :is_on_house, :boolean, default: false
  end

  def down
    remove_column :master_plan_items, :is_on_house
  end
end
