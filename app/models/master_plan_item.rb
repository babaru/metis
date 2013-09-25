class MasterPlanItem < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :master_plan
  belongs_to :spot
  belongs_to :website
  belongs_to :channel
  has_many :spot_plan_items, dependent: :destroy

  attr_accessible :count, :spot_id, :master_plan_id, :is_on_house, :project_id, :client_id, :website_id, :channel_id, :website_name, :channel_name, :position_name, :material_format, :pv_tracking, :click_tracking, :link_to_official_site, :mr_deadline, :est_imp, :est_clicks, :est_total_imp, :est_total_clicks, :est_ctr, :est_cpc, :est_cpm, :days, :cpc, :unit_rate_card, :discount, :net_cost, :total_rate_card

  def reality_count(version = nil)
    version = self.master_plan.working_version if version.nil?
    result = MasterPlanItem.connection.select_all("select sum(count) as reality_count from spot_plan_items where version=#{version} and master_plan_item_id=#{self.id} and placed_at>='#{master_plan.project.started_at.utc.strftime('%Y-%m-%d %H:%M:%S')}' and placed_at<='#{master_plan.project.ended_at.utc.strftime('%Y-%m-%d %H:%M:%S')}'")
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
    item['est_total_imp'] = self.est_total_imp
    item['est_total_clicks'] = self.est_total_clicks
    item
  end

  # Attributes

  def position_name_value
    return spot.name if spot_id
    position_name
  end

  def channel_name_value
    return channel_name if channel_name
    channel.name
  end

  def spot_price_value
    return spot.price if spot_id
    price
  end
end
