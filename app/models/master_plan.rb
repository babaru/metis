class MasterPlan < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id

  has_many :items, class_name: 'MasterPlanItem', dependent: :destroy

  attr_accessible :project_id, :created_by_id, :name, :client_id, :is_dirty, :is_readonly

  def contract_price
    sum = 0
    items.where(is_on_house: false).each do |item|
      sum += (item.spot.price * item.count * project.client.our_discount_value(item.spot.website_id)) if item.spot_id
    end
    sum
  end

  def cost
    sum = 0
    items.where(is_on_house: false).each do |item|
      sum += (item.spot.price * item.count * project.client.website_discount_value(item.spot.website_id)) if item.spot_id
    end
    sum
  end

  def profit
    contract_price - cost
  end

  def website_contract_price(website_id)
    sum = 0
    items.where(is_on_house: false, website_id: website_id).each do |item|
      sum += (item.spot.price * item.count * project.client.our_discount_value(website_id)) if item.spot_id
    end
    sum
  end

  def website_cost(website_id)
    sum = 0
    items.where(is_on_house: false, website_id: website_id).each do |item|
      sum += (item.spot.price * item.count * project.client.website_discount_value(website_id)) if item.spot_id
    end
    sum
  end

  def website_profit(website_id)
    website_contract_price(website_id) - website_cost(website_id)
  end

  def on_house_rate(website_id)
    total_price = 0
    items.joins('left join spots on spot_id=spots.id').where("is_on_house=0 and spots.website_id=#{website_id}").each do |item|
      total_price += item.spot.price * item.count * item.master_plan.project.client.our_discount_value(item.spot.website_id)
    end

    on_house_amount = 0
    items.joins('left join spots on spot_id=spots.id').where("is_on_house=1 and spots.website_id=#{website_id}").each do |item|
      on_house_amount += item.spot.price * item.count
    end
    (on_house_amount.to_f / total_price.to_f).to_f.round(2)
  end

  def working_version
    result = MasterPlan.connection.select_all("select max(version) as working_version from spot_plan_items where master_plan_id=#{id}")
    return result[0]['working_version'] if result.length > 0 && result[0]['working_version']
    1
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
end
