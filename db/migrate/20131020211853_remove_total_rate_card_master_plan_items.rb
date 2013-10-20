class RemoveTotalRateCardMasterPlanItems < ActiveRecord::Migration
  def up
    remove_column :master_plan_items, :total_rate_card
  end

  def down
    add_column :master_plan_items, :total_rate_card, :decimal
  end
end
