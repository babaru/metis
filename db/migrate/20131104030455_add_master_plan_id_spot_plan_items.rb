class AddMasterPlanIdSpotPlanItems < ActiveRecord::Migration
  def up
    add_column :spot_plan_items, :master_plan_id, :integer
    add_index :spot_plan_items, :master_plan_id

    SpotPlanItem.transaction do
      SpotPlanItem.all.each do |item|
        item.master_plan_id = item.master_plan_item.master_plan_id
        item.save!
      end
    end
  end

  def down
    remove_column :spot_plan_items, :master_plan_id
    remove_index :spot_plan_items, :master_plan_id
  end
end
