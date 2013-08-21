class MasterPlanItem < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :master_plan
  belongs_to :spot
  belongs_to :website
  belongs_to :channel
  has_many :spot_plan_items, dependent: :destroy

  attr_accessible :count, :spot_id, :master_plan_id, :is_on_house, :project_id, :client_id, :website_id, :channel_id

  def spot_plan_item_count(date)
    item = spot_plan_items.find_by_placed_at(Time.parse(date))
    return item.count if item
    ''
  end

  def reality_count
    result = MasterPlanItem.connection.select_all("select sum(count) as reality_count from spot_plan_items where master_plan_item_id=#{self.id} and placed_at>='#{master_plan.project.started_at.utc.strftime('%Y-%m-%d %H:%M:%S')}' and placed_at<='#{master_plan.project.ended_at.utc.strftime('%Y-%m-%d %H:%M:%S')}'")
    return result[0]['reality_count'] if result.length > 0 && result[0]['reality_count']
    0
  end

  def as_json(options={})
    item = super(options)
    item['website_name'] = self.spot.website.name
    item['channel_name'] = self.spot.channel.name
    item['spot_name'] = self.spot.name
    item['ideal_count'] = self.count
    item['reality_count'] = self.reality_count
    item
  end
end
