class MediumMasterPlan < ActiveRecord::Base
  belongs_to :master_plan
  belongs_to :medium
  attr_accessible :reality_medium_net_cost, :reality_company_net_cost,
    :reality_medium_discount, :reality_company_discount,
    :original_medium_discount, :original_company_discount,
    :medium_id, :medium_name,
    :master_plan_id, :master_plan_name,
    :type

  before_create :copy_mandatory_attributes

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

  private

  def copy_mandatory_attributes

  end
end
