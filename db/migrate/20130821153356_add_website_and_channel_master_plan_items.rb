class AddWebsiteAndChannelMasterPlanItems < ActiveRecord::Migration
  def up
    add_column :master_plan_items, :website_id, :integer
    add_column :master_plan_items, :channel_id, :integer
    add_index :master_plan_items, :website_id
    add_index :master_plan_items, :channel_id

    MasterPlanItem.transaction do
      MasterPlanItem.all.each do |item|
        item.website_id = item.spot.website_id
        item.channel_id = item.spot.channel_id
        item.save!
      end
    end
  end

  def down
    remove_column :master_plan_items, :website_id
    remove_column :master_plan_items, :channel_id
    remove_index :master_plan_items, :website_id
    remove_index :master_plan_items, :channel_id
  end
end
