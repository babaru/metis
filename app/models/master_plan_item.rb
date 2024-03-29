class MasterPlanItem < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :master_plan
  belongs_to :medium_master_plan
  belongs_to :spot
  belongs_to :medium
  belongs_to :channel
  has_many :spot_plan_items, dependent: :destroy

  before_create :copy_mandatory_attributes

  attr_accessible :count, :cpm,
    :spot, :spot_id, :spot_name, :reality_spot_name,
    :master_plan, :master_plan_id, :master_plan_name,
    :project, :project_id, :project_name,
    :client, :client_id, :client_name,
    :medium, :medium_id, :medium_name,
    :channel, :channel_id, :channel_name,
    :medium_master_plan_id,
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
    :leads,
    :unit_rate_card, :unit_rate_card_unit, :unit_rate_card_unit_type,
    :reality_medium_net_cost, :reality_company_net_cost,
    :original_medium_discount, :reality_medium_discount,
    :original_company_discount, :reality_company_discount,
    :type

  def reality_count(version = nil)
    version = self.master_plan.spot_plan_version if version.nil?
    result = MasterPlanItem.connection.select_all("select sum(count) as reality_count from spot_plan_items where version=#{version} and master_plan_item_id=#{self.id} and placed_at>='#{master_plan.project.started_at.utc.strftime('%Y-%m-%d %H:%M:%S')}' and placed_at<='#{master_plan.project.ended_at.utc.strftime('%Y-%m-%d %H:%M:%S')}'")
    return result[0]['reality_count'] if result.length > 0 && result[0]['reality_count']
    0
  end

  def as_json(options={})
    item = super(options)
    item['ideal_count'] = self.count
    item['reality_count'] = self.reality_count
    item['medium_net_cost'] = self.medium_net_cost
    item['company_net_cost'] = self.company_net_cost
    item
  end

  def medium_net_cost
    return 0 if is_on_house?
    return reality_medium_net_cost if reality_medium_net_cost && (medium_master_plan.is_combo? || medium_master_plan.is_history?)
    theoritical_medium_net_cost
  end

  def medium_net_cost_by_month(year, month)
    target_spot_plan_items = self.spot_plan_items.where(placed_at: (Date.new(year, month, 1)..Date.new(year, month, 1).end_of_month()))
    (self.medium_net_cost / self.count) * target_spot_plan_items.count
  end

  def theoritical_medium_net_cost
    r_count = self.reality_count
    return unit_rate_card * r_count * original_medium_discount if r_count > 0
    unit_rate_card * count * original_medium_discount
  end

  def company_net_cost
    return 0 if is_on_house?
    return reality_company_net_cost if reality_company_net_cost && (medium_master_plan.is_combo? || medium_master_plan.is_history?)
    theoritical_company_net_cost
  end

  def company_net_cost_by_month(year, month)
    target_spot_plan_items = self.spot_plan_items.where(placed_at: (Date.new(year, month, 1)..Date.new(year, month, 1).end_of_month()))
    (self.company_net_cost / self.count) * target_spot_plan_items.count
  end

  def theoritical_company_net_cost
    r_count = self.reality_count
    return unit_rate_card * r_count * original_company_discount if r_count > 0
    unit_rate_card * count * original_company_discount
  end

  def total_rate_card
    r_count = self.reality_count
    return unit_rate_card * r_count if r_count > 0
    unit_rate_card * count
  end

  def unit_rate_card_per_day
    self.unit_rate_card
  end

  def self.create_by_data!(data)
    item = MasterPlanItem.find_by_master_plan_id_and_spot_id_and_is_on_house(data[:master_plan_id], data[:spot_id], data[:is_on_house])
    if item
      item.count += data[:count]
      item.save!
    else
      item = MasterPlanItem.create!(data)
    end
    item
  end

  def medium_discount
    return reality_medium_discount if reality_medium_discount && (medium_master_plan.is_combo? || medium_master_plan.is_history?)
    original_medium_discount
  end

  def company_discount
    return reality_company_discount if reality_company_discount && (medium_master_plan.is_combo? || medium_master_plan.is_history?)
    original_company_discount
  end

  def position_name
    return reality_spot_name if reality_spot_name
    spot_name
  end

  def est_cpm_cost
    total_rate_card / est_total_imp * 1000
  end

  def est_cpc_cost
    total_rate_card / est_total_clicks
  end

  private

  def copy_mandatory_attributes
    if spot_id
      self.spot_name = self.spot.name unless self.spot_name
      self.reality_spot_name = self.spot.name unless self.spot_name
      self.unit_rate_card = self.spot.price unless self.unit_rate_card
      self.unit_rate_card_unit = self.spot.unit unless self.unit_rate_card_unit
      self.unit_rate_card_unit_type = self.spot.unit_type unless self.unit_rate_card_unit_type
      self.material_format = self.spot.spec unless self.material_format
      self.master_plan_name = self.master_plan.name unless master_plan_name
      self.project_name = self.project.name unless project_name
      self.client_name = self.client.name unless client_name
      self.medium_name = self.spot.medium.name unless medium_name
      self.channel_name = self.spot.channel.name unless channel_name
      self.original_medium_discount = MediumPolicy.medium_discount(self.medium_id, self.client_id) unless original_medium_discount
      self.original_company_discount = MediumPolicy.company_discount(self.medium_id, self.client_id) unless original_company_discount
    end
  end
end
