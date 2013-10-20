class MediumMasterPlan < ActiveRecord::Base
  belongs_to :master_plan
  belongs_to :medium
  attr_accessible :reality_medium_net_cost, :reality_company_net_cost,
    :medium_id, :medium_name,
    :master_plan_id, :master_plan_name

  def medium_net_cost
    return reality_medium_net_cost if reality_medium_net_cost
    sum = 0
    MasterPlanItem.where(medium_id: medium_id, master_plan_id: master_plan_id, is_on_house: false).each do |item|
      sum += item.theoritical_medium_net_cost
    end
    sum
  end

  def company_net_cost
    return reality_company_net_cost if reality_company_net_cost
    sum = 0
    MasterPlanItem.where(medium_id: medium_id, master_plan_id: master_plan_id, is_on_house: false).each do |item|
      sum += item.theoritical_company_net_cost
    end
    sum
  end
end
