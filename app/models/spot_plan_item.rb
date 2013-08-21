class SpotPlanItem < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :master_plan
  belongs_to :master_plan_item
  belongs_to :spot
  belongs_to :website
  belongs_to :channel
  belongs_to :created_by
  belongs_to :previous_spot_plan_item, class_name: 'SpotPlanItem', foreign_key: :previous_spot_plan_item_id

  attr_accessible :count, :is_enabled, :placed_at, :master_plan_item_id, :created_by_id, :master_plan_item_reality_count, :version, :previous_spot_plan_item_id, :client_id, :project_id, :master_plan_id, :spot_id, :website_id, :channel_id
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
