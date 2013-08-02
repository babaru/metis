class CreateMasterPlanItems < ActiveRecord::Migration
  def change
    create_table :master_plan_items do |t|
      t.references :spot
      t.references :master_plan
      t.decimal :count

      t.timestamps
    end
    add_index :master_plan_items, :spot_id
    add_index :master_plan_items, :master_plan_id
  end
end
