class MediumMasterPlan < ActiveRecord::Base
  belongs_to :master_plan
  belongs_to :medium
  has_many :master_plan_items
  attr_accessible :reality_medium_net_cost, :reality_company_net_cost,
    :reality_medium_discount, :reality_company_discount,
    :original_medium_discount, :original_company_discount,
    :medium_id, :medium_name,
    :master_plan_id, :master_plan_name,
    :type

  before_create :copy_name_attributes, :copy_discount_attributes

  def medium_net_cost
    sum = 0
    MasterPlanItem.where(medium_id: medium_id, master_plan_id: master_plan_id, is_on_house: false).each do |item|
      sum += item.theoritical_medium_net_cost
    end
    sum
  end

  def company_net_cost
    sum = 0
    MasterPlanItem.where(medium_id: medium_id, master_plan_id: master_plan_id, is_on_house: false).each do |item|
      sum += item.theoritical_company_net_cost
    end
    sum
  end

  def medium_discount
    original_medium_discount
  end

  def company_discount
    original_company_discount
  end

  def profit
    company_net_cost - medium_net_cost
  end

  def bonus_ratio
    total_price = 0
    master_plan_items.where("is_on_house=0").each do |item|
      total_price += item.company_net_cost
    end

    on_house_amount = 0
    master_plan_items.where("is_on_house=1").each do |item|
      on_house_amount += item.total_rate_card
    end
    (on_house_amount.to_f / total_price.to_f).to_f.round(2)
  end

  def self.create_by_data!(data)
    item = MediumMasterPlan.find_by_master_plan_id_and_medium_id(data[:master_plan_id], data[:medium_id])
    if item
      if data[:is_combo] && !item.is_a?(ComboMediumMasterPlan)
        item.type = ComboMediumMasterPlan.name
        item.save!
      end
    else
      type = MediumMasterPlan.name
      type = ComboMediumMasterPlan.name if data[:is_combo]
      data.delete(:is_combo)
      data[:type] = type
      item = MediumMasterPlan.create!(data)
    end
    item
  end

  def is_combo?
    false
  end

  def as_json(options={})
    item = super(options)
    item[:bonus_ratio] = self.bonus_ratio
    item[:medium_net_cost] = self.medium_net_cost
    item[:company_net_cost] = self.company_net_cost
    item[:profit] = self.profit
    item[:medium_discount] = self.medium_discount
    item[:company_discount] = self.company_discount
    item[:medium_bonus_ratio] = MediumPolicy.medium_bonus_ratio(self.medium_id, self.master_plan.client_id)
    item[:company_bonus_ratio] = MediumPolicy.company_bonus_ratio(self.medium_id, self.master_plan.client_id)
    item
  end

  private

  def copy_name_attributes
    self.medium_name = self.medium.name unless self.medium_name
    self.master_plan_name = self.master_plan.name unless self.master_plan_name
  end

  def copy_discount_attributes
    self.original_medium_discount = MediumPolicy.medium_discount(self.medium_id, self.master_plan.client_id) unless self.original_medium_discount
    self.original_company_discount = MediumPolicy.company_discount(self.medium_id, self.master_plan.client_id) unless self.original_company_discount
  end
end
