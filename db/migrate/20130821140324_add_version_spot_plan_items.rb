class AddVersionSpotPlanItems < ActiveRecord::Migration
  def up
    add_column :spot_plan_items, :version, :integer, default: 0
    add_column :spot_plan_items, :previous_spot_plan_item_id, :integer
    add_index :spot_plan_items, :previous_spot_plan_item_id
    execute "UPDATE spot_plan_items SET version=1"
  end

  def down
    remove_column :spot_plan_items, :version
    remove_column :spot_plan_items, :previous_spot_plan_item_id
    remove_index :spot_plan_items, :previous_spot_plan_item_id
  end
end
