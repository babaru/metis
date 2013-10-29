class SimplifySpotPlanItem < ActiveRecord::Migration
  def up
    remove_column :spot_plan_items, :is_enabled
    remove_column :spot_plan_items, :created_by_id
    remove_column :spot_plan_items, :client_id
    remove_column :spot_plan_items, :project_id
    remove_column :spot_plan_items, :spot_id
    remove_column :spot_plan_items, :master_plan_id
    remove_column :spot_plan_items, :channel_id
    remove_column :spot_plan_items, :medium_id

    add_index :spot_plan_items, :master_plan_item_id
    add_index :spot_plan_items, :new_spot_plan_item_id
  end

  def down
    add_column :spot_plan_items, :is_enabled, :boolean, default: true
    add_column :spot_plan_items, :created_by_id, :integer
    add_column :spot_plan_items, :client_id, :integer
    add_column :spot_plan_items, :project_id, :integer
    add_column :spot_plan_items, :spot_id, :integer
    add_column :spot_plan_items, :master_plan_id, :integer
    add_column :spot_plan_items, :channel_id, :integer
    add_column :spot_plan_items, :medium_id, :integer

    remove_index :spot_plan_items, :master_plan_item_id
    remove_index :spot_plan_items, :new_spot_plan_item_id
  end
end
