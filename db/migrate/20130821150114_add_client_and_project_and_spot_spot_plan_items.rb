class AddClientAndProjectAndSpotSpotPlanItems < ActiveRecord::Migration
  def up
    add_column :spot_plan_items, :client_id, :integer
    add_column :spot_plan_items, :project_id, :integer
    add_column :spot_plan_items, :spot_id, :integer
    add_column :spot_plan_items, :master_plan_id, :integer
    add_index :spot_plan_items, :client_id
    add_index :spot_plan_items, :project_id
    add_index :spot_plan_items, :spot_id
    add_index :spot_plan_items, :master_plan_id

    SpotPlanItem.transaction do
      MasterPlanItem.all.each do |master_plan_item|
        master_plan_item.spot_plan_items.each do |item|
          item.client_id = master_plan_item.client_id
          item.project_id = master_plan_item.project_id
          item.spot_id = master_plan_item.spot_id
          item.master_plan_id = master_plan_item.master_plan_id
          item.save!
        end
      end
    end
  end

  def down
    remove_column :spot_plan_items, :client_id
    remove_column :spot_plan_items, :project_id
    remove_column :spot_plan_items, :spot_id
    remove_column :spot_plan_items, :master_plan_id
    remove_index :spot_plan_items, :client_id
    remove_index :spot_plan_items, :project_id
    remove_index :spot_plan_items, :spot_id
    remove_index :spot_plan_items, :master_plan_id
  end
end
