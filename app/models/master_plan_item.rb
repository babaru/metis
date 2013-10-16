class MasterPlanItem < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :master_plan
  belongs_to :spot
  belongs_to :medium
  belongs_to :channel
  has_many :spot_plan_items, dependent: :destroy

  before_create :copy_useful_attributes

  attr_accessible :count,
    :spot, :spot_id, :spot_name,
    :master_plan, :master_plan_id, :master_plan_name,
    :project, :project_id, :project_name,
    :client, :client_id, :client_name,
    :medium, :medium_id, :medium_name,
    :channel, :channel_id, :channel_name,
    :is_on_house,
    :material_format,
    :pv_tracking,
    :click_tracking,
    :link_to_official_site,
    :mr_deadline,
    :est_imp,
    :est_clicks,
    :est_total_imp,
    :est_total_clicks,
    :est_ctr,
    :est_cpc,
    :est_cpm,
    :cpc,
    :unit_rate_card, :unit_rate_card_unit, :unit_rate_card_unit_type,
    :net_cost,
    :total_rate_card,
    :medium_discount,
    :company_discount,
    :medium_bonus_ratio,
    :company_bonus_ratio

  def reality_count(version = nil)
    version = self.master_plan.working_version if version.nil?
    result = MasterPlanItem.connection.select_all("select sum(count) as reality_count from spot_plan_items where version=#{version} and master_plan_item_id=#{self.id} and placed_at>='#{master_plan.project.started_at.utc.strftime('%Y-%m-%d %H:%M:%S')}' and placed_at<='#{master_plan.project.ended_at.utc.strftime('%Y-%m-%d %H:%M:%S')}'")
    return result[0]['reality_count'] if result.length > 0 && result[0]['reality_count']
    0
  end

  def as_json(options={})
    item = super(options)
    item['medium_name'] = self.spot.medium.name
    item['channel_name'] = self.spot.channel.name
    item['spot_name'] = self.spot.name
    item['ideal_count'] = self.count
    item['reality_count'] = self.reality_count
    item['est_total_imp'] = self.est_total_imp
    item['est_total_clicks'] = self.est_total_clicks
    item
  end

  private

  def copy_useful_attributes
    if self.new_record?
      self.spot_name = self.spot.name if self.spot_id
      self.unit_rate_card = self.spot.price if self.spot_id
      self.unit_rate_card_unit = self.spot.unit if self.spot_id
      self.unit_rate_card_unit_type = self.spot.unit_type if self.spot_id
      self.master_plan_name = self.master_plan.name if self.master_plan_id
      self.project_name = self.project.name if self.project_id
      self.client_name = self.client.name if self.client_id
      self.medium_name = self.medium.name if self.medium_id
      self.channel_name = self.channel.name if self.channel_id
      self.medium_discount = self.spot.medium_discount(self.client_id) if self.spot_id
      self.company_discount = self.spot.company_discount(self.client_id) if self.spot_id
      self.medium_bonus_ratio = self.spot.medium_bonus_ratio(self.client_id) if self.spot_id
      self.company_bonus_ratio = self.spot.company_bonus_ratio(self.client_id) if self.spot_id
    else
    end
  end
end
