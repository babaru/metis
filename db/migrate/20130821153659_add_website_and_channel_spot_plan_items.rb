class AddWebsiteAndChannelSpotPlanItems < ActiveRecord::Migration
  def up
    add_column :spot_plan_items, :website_id, :integer
    add_column :spot_plan_items, :channel_id, :integer
    add_index :spot_plan_items, :website_id
    add_index :spot_plan_items, :channel_id

    SpotPlanItem.transaction do
      SpotPlanItem.all.each do |item|
        item.website_id = item.spot.website_id
        item.channel_id = item.spot.channel_id
        item.save!
      end
    end
  end

  def down
    remove_column :spot_plan_items, :website_id
    remove_column :spot_plan_items, :channel_id
    remove_index :spot_plan_items, :website_id
    remove_index :spot_plan_items, :channel_id
  end
end
