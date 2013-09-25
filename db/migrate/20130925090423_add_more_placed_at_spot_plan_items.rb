class AddMorePlacedAtSpotPlanItems < ActiveRecord::Migration
  def up
    add_column :spot_plan_items, :date_id, :string

    SpotPlanItem.all.each do |item|
      item.date_id = item.placed_at.strftime('%Y%m%d') if item.placed_at
      item.save
    end

    # remove_column :spot_plan_items, :placed_at
  end

  def down
    # add_column :spot_plan_items, :placed_at, :datetime

    SpotPlanItem.all.each do |item|
      item.placed_at = DateTime.strptime("#{item.date_id}+08:00", '%Y%m%d%z') if item.date_id
      item.save
    end

    remove_column :spot_plan_items, :date_id
  end
end
