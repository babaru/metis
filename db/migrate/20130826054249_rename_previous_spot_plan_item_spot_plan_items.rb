class RenamePreviousSpotPlanItemSpotPlanItems < ActiveRecord::Migration
  def up
    rename_column :spot_plan_items, :previous_spot_plan_item_id, :new_spot_plan_item_id
  end

  def down
    rename_column :spot_plan_items, :new_spot_plan_item_id, :previous_spot_plan_item_id
  end
end
