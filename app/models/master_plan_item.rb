class MasterPlanItem < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :master_plan
  belongs_to :medium_master_plan
  belongs_to :spot
  belongs_to :medium
  belongs_to :channel
  has_many :spot_plan_items, dependent: :destroy

  before_create :copy_useful_attributes

  attr_accessible :count,
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
    :est_cpm,
    :cpc,
    :unit_rate_card, :unit_rate_card_unit, :unit_rate_card_unit_type,
    :reality_medium_net_cost, :reality_company_net_cost,
    :original_medium_discount, :reality_medium_discount,
    :original_company_discount, :reality_company_discount

  def reality_count(version = nil)
    version = self.master_plan.working_version if version.nil?
    result = MasterPlanItem.connection.select_all("select sum(count) as reality_count from spot_plan_items where version=#{version} and master_plan_item_id=#{self.id} and placed_at>='#{master_plan.project.started_at.utc.strftime('%Y-%m-%d %H:%M:%S')}' and placed_at<='#{master_plan.project.ended_at.utc.strftime('%Y-%m-%d %H:%M:%S')}'")
    return result[0]['reality_count'] if result.length > 0 && result[0]['reality_count']
    0
  end

  def as_json(options={})
    item = super(options)
    item['medium_name'] = self.medium_name
    item['channel_name'] = self.channel_name
    item['spot_name'] = self.spot_name
    item['reality_spot_name'] = self.reality_spot_name
    item['ideal_count'] = self.count
    item['reality_count'] = self.reality_count
    item['est_total_imp'] = self.est_total_imp
    item['est_total_clicks'] = self.est_total_clicks
    item
  end

  def medium_net_cost
    return 0 if is_on_house?
    return reality_medium_net_cost if reality_medium_net_cost && medium_master_plan.is_combo?
    theoritical_medium_net_cost
  end

  def theoritical_medium_net_cost
    unit_rate_card * count * original_medium_discount
  end

  def company_net_cost
    return 0 if is_on_house?
    return reality_company_net_cost if reality_company_net_cost && medium_master_plan.is_combo?
    theoritical_company_net_cost
  end

  def theoritical_company_net_cost
    unit_rate_card * count * original_company_discount
  end

  def total_rate_card
    unit_rate_card * count
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
    return reality_medium_discount if reality_medium_discount && medium_master_plan.is_combo?
    original_medium_discount
  end

  def company_discount
    return reality_company_discount if reality_company_discount && medium_master_plan.is_combo?
    original_company_discount
  end

  private

  def copy_useful_attributes
    if self.new_record?
      self.spot_name = self.spot.name if self.spot_id
      self.reality_spot_name = self.spot.name if self.spot_id
      self.unit_rate_card = self.spot.price if self.spot_id
      self.unit_rate_card_unit = self.spot.unit if self.spot_id
      self.unit_rate_card_unit_type = self.spot.unit_type if self.spot_id
      self.master_plan_name = self.master_plan.name if self.master_plan_id
      self.project_name = self.project.name if self.project_id
      self.client_name = self.client.name if self.client_id
      self.medium_name = self.spot.medium.name if self.spot_id
      self.channel_name = self.spot.channel.name if self.spot_id
      self.reality_medium_discount = self.spot.medium_discount(self.client_id) if self.spot_id
      self.reality_company_discount = self.spot.company_discount(self.client_id) if self.spot_id
      self.original_medium_discount = self.spot.medium_discount(self.client_id) if self.spot_id
      self.original_company_discount = self.spot.company_discount(self.client_id) if self.spot_id
    else
    end
  end
end
