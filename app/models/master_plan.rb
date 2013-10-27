class MasterPlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :client
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :items, class_name: 'MasterPlanItem', dependent: :destroy
  has_many :medium_master_plans, dependent: :destroy

  attr_accessible :name,
    :project_id,
    :project_name,
    :created_by_id,
    :created_by_name,
    :client_id,
    :client_name,
    :is_dirty,
    :is_readonly,
    :reality_medium_net_cost,
    :reality_company_net_cost

  def medium_master_plan(medium_id)
    medium_master_plans.where(medium_id: medium_id).first
  end

  def medium_net_cost(medium_id = nil)
    return medium_master_plan(medium_id).medium_net_cost if medium_id
    return reality_medium_net_cost if reality_medium_net_cost
    medium_master_plans.inject(0) {|sum, item| sum += item.medium_net_cost }
  end

  def company_net_cost(medium_id = nil)
    return medium_master_plan(medium_id).company_net_cost if medium_id
    return reality_company_net_cost if reality_company_net_cost
    medium_master_plans.inject(0) {|sum, item| sum += item.company_net_cost }
  end

  def profit(medium_id = nil)
    medium_net_cost(medium_id) - company_net_cost(medium_id)
  end

  def medium_net_costs_per_medium()
    result = {}
    candidate_media.each do |medium|
      result[medium.id] = medium_net_cost(medium.id)
    end
    result
  end

  def company_net_costs_per_medium()
    result = {}
    candidate_media.each do |medium|
      result[medium.id] = company_net_cost(medium.id)
    end
    result
  end

  def profits_per_medium()
    result = {}
    candidate_media.each do |medium|
      result[medium.id] = profit(medium.id)
    end
    result
  end

  def reality_bonus_ratio(medium_id)
    return 0 unless medium_id
    total_price = 0
    items.where("is_on_house=0 and medium_id=?", medium_id).each do |item|
      total_price += item.theoritical_company_net_cost
    end

    on_house_amount = 0
    items.where("is_on_house=1 and medium_id=?", medium_id).each do |item|
      on_house_amount += item.total_rate_card
    end
    (on_house_amount.to_f / total_price.to_f).to_f.round(2)
  end

  def reality_bonus_ratios_per_medium()
    result = {}
    candidate_media.each do |medium|
      result[medium.id] = reality_bonus_ratio(medium.id)
    end
    result
  end

  def medium_bonus_ratio(medium_id)
    MediumPolicy.medium_bonus_ratio(medium_id, client_id)
  end

  def medium_bonus_ratios_per_medium()
    result = {}
    candidate_media.each do |medium|
      result[medium.id] = medium_bonus_ratio(medium.id)
    end
    result
  end

  def company_bonus_ratio(medium_id)
    MediumPolicy.company_bonus_ratio(medium_id, client_id)
  end

  def company_bonus_ratios_per_medium()
    result = {}
    candidate_media.each do |medium|
      result[medium.id] = company_bonus_ratio(medium.id)
    end
    result
  end

  def spots_count(medium_id = nil)
    return self.items.count unless medium_id
    self.items.where('medium_id=?', medium_id).count
  end

  def working_version
    result = MasterPlan.connection.select_all("select max(version) as working_version from spot_plan_items where master_plan_id=#{id}")
    return result[0]['working_version'] if result.length > 0 && result[0]['working_version']
    0
  end

  def candidate_media
    Medium.find_by_sql("select * from media where id in (select distinct medium_id from master_plan_items where master_plan_id=#{id})")
  end

  def save_version!
    working_version = self.working_version
    MasterPlan.transaction do
      spot_plan_items = SpotPlanItem.where('master_plan_id=? and version=? and count>0', self.id, working_version)
      spot_plan_items.each {|item| item.copy_to_new_version!(working_version + 1)}
      self.is_dirty = false
      self.save!
    end
  end

  def import_from_excel(excel_file)
    Tida::ExcelParsers::MasterPlanParser.parse excel_file
  end

  def as_json(options={})
    item = super(options)
    item[:budget] = self.project.budget
    item[:medium_net_cost] = self.medium_net_cost
    item[:company_net_cost] = self.company_net_cost
    item[:profit] = self.profit
    item[:medium_net_costs_per_medium] = self.medium_net_costs_per_medium
    item[:company_net_costs_per_medium] = self.company_net_costs_per_medium
    item[:profits_per_medium] = self.profits_per_medium
    item[:reality_bonus_ratios_per_medium] = self.reality_bonus_ratios_per_medium
    item[:medium_bonus_ratios_per_medium] = self.medium_bonus_ratios_per_medium
    item[:company_bonus_ratios_per_medium] = self.company_bonus_ratios_per_medium
    item
  end
end
