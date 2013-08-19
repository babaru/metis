class SpotPlanItem < ActiveRecord::Base
  belongs_to :master_plan_item
  belongs_to :created_by
  attr_accessible :count, :is_enabled, :placed_at, :master_plan_item_id, :created_by_id, :master_plan_item_reality_count
  attr_accessor :master_plan_item_reality_count

  def as_json(options={})
    item = super(options)
    item['master_plan_item_reality_count'] = self.master_plan_item_reality_count
    item['date_token'] = self.placed_at.strftime('%Y%m%d')
    item['day_index'] = self.placed_at.strftime('%d')
    item['placed_at'] = self.placed_at.strftime('%Y-%m-%d')
    item
  end
end
