class MasterPlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :client
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :items, class_name: 'MasterPlanItem', dependent: :destroy
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

  def medium_contract_price(medium_id = nil)
    sum = 0
    condition = {is_on_house: false}
    condition[:medium_id] = medium_id if medium_id
    items.where(condition).each do |item|
      sum += (item.spot.price * item.count * MediumPolicy.company_discount(item.spot.medium_id, client_id)) if item.spot_id
    end
    sum
  end

  def company_contract_price(medium_id = nil)
    sum = 0
    condition = {is_on_house: false}
    condition[:medium_id] = medium_id if medium_id
    items.where(condition).each do |item|
      sum += (item.spot.price * item.count * MediumPolicy.medium_discount(item.spot.medium_id, client_id)) if item.spot_id
    end
    sum
  end

  def profit(medium_id = nil)
    medium_contract_price(medium_id) - company_contract_price(medium_id)
  end

  def medium_contract_prices()
    result = {}
    candidate_media.each do |medium|
      result[medium.id] = medium_contract_price(medium.id)
    end
    result
  end

  def medium_profits()
    result = {}
    candidate_media.each do |medium|
      result[medium.id] = profit(medium.id)
    end
    result
  end

  def medium_bonus_ratio(medium_id)
    self.client.medium_bonus_ratio(medium_id)
  end

  def medium_bonus_ratios()
    candidate_media.inject([]) {|list, medium| list << medium_bonus_ratio(medium.id)}
  end

  def company_bonus_ratio(medium_id)
    self.client.company_bonus_ratio(medium_id)
  end

  def company_bonus_ratios()
    candidate_media.inject([]) {|list, medium| list << company_bonus_ratio(medium.id)}
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
    item[:budget] = number_to_currency(self.project.budget, precision: 0, unit: '')
    item[:medium_contract_price] = number_to_currency(self.medium_contract_price, precision: 0, unit: '')
    item[:company_contract_price] = number_to_currency(self.company_contract_price, precision: 0, unit: '')
    item[:profit] = number_to_currency(self.profit, precision: 0, unit: '')
    item[:medium_contract_prices] = self.medium_contract_prices
    item[:medium_profits] = self.medium_profits
    # item[:reality_bonus_ratios] = self.reality_bonus_ratios
    item[:medium_bonus_ratios] = self.medium_bonus_ratios
    item[:company_bonus_ratios] = self.company_bonus_ratios
    item
  end
end
