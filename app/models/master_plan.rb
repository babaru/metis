class MasterPlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :client
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :items, class_name: 'MasterPlanItem', dependent: :destroy
  attr_accessible :name, :project_id, :created_by_id, :client_id, :is_dirty,
    :is_readonly

  def contract_price(website_id = nil)
    sum = 0
    condition = {is_on_house: false}
    condition[:website_id] = website_id if website_id
    items.where(condition).each do |item|
      sum += (item.spot.price * item.count * client.company_discount(item.spot.website_id)) if item.spot_id
    end
    sum
  end

  def cost(website_id = nil)
    sum = 0
    condition = {is_on_house: false}
    condition[:website_id] = website_id if website_id
    items.where(condition).each do |item|
      sum += (item.spot.price * item.count * client.website_discount(item.spot.website_id)) if item.spot_id
    end
    sum
  end

  def profit(website_id = nil)
    contract_price(website_id) - cost(website_id)
  end

  def website_contract_prices()
    result = {}
    candidate_websites.each do |website|
      result[website.id] = contract_price(website.id)
    end
    result
  end

  def website_profits()
    result = {}
    candidate_websites.each do |website|
      result[website.id] = profit(website.id)
    end
    result
  end

  def reality_bonus_ratio(website_id)
    return 0 unless website_id
    total_price = 0
    items.joins('left join spots on spot_id=spots.id').where("is_on_house=0 and spots.website_id=#{website_id}").each do |item|
      total_price += item.spot.price * item.count * item.client.company_discount(item.spot.website_id)
    end

    on_house_amount = 0
    items.joins('left join spots on spot_id=spots.id').where("is_on_house=1 and spots.website_id=#{website_id}").each do |item|
      on_house_amount += item.spot.price * item.count
    end
    (on_house_amount.to_f / total_price.to_f).to_f.round(2)
  end

  def reality_bonus_ratios()
    result = {}
    candidate_websites.each do |website|
      result[website.id] = reality_bonus_ratio(website.id)
    end
    result
  end

  def website_bonus_ratio(website_id)
    self.client.website_bonus_ratio(website_id)
  end

  def website_bonus_ratios()
    candidate_websites.inject([]) {|list, website| list << website_bonus_ratio(website.id)}
  end

  def company_bonus_ratio(website_id)
    self.client.company_bonus_ratio(website_id)
  end

  def company_bonus_ratios()
    candidate_websites.inject([]) {|list, website| list << company_bonus_ratio(website.id)}
  end

  def working_version
    result = MasterPlan.connection.select_all("select max(version) as working_version from spot_plan_items where master_plan_id=#{id}")
    return result[0]['working_version'] if result.length > 0 && result[0]['working_version']
    0
  end

  def candidate_websites
    Website.find_by_sql("select * from websites where id in (select distinct website_id from master_plan_items where master_plan_id=#{id})")
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
    item[:contract_price] = number_to_currency(self.contract_price, precision: 0, unit: '')
    item[:profit] = number_to_currency(self.profit, precision: 0, unit: '')
    item[:website_contract_prices] = self.website_contract_prices
    item[:website_profits] = self.website_profits
    item[:reality_bonus_ratios] = self.reality_bonus_ratios
    item[:website_bonus_ratios] = self.website_bonus_ratios
    item[:company_bonus_ratios] = self.company_bonus_ratios
    item
  end
end
