class CreateSpotPlanItems < ActiveRecord::Migration
  def change
    create_table :spot_plan_items do |t|
      t.references :master_plan_item
      t.datetime :placed_at
      t.integer :count
      t.boolean :is_enabled
      t.references :created_by

      t.timestamps
    end
    add_index :spot_plan_items, :master_plan_item_id
    add_index :spot_plan_items, :created_by_id
  end
end
