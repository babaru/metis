class MasterPlanItem < ActiveRecord::Base
  belongs_to :spot
  belongs_to :master_plan
  attr_accessible :count, :spot_id, :master_plan_id, :is_on_house

  def discount_value(website_id, options={})
    self.master_plan.project.client.discount_value(website_id, options)
  end
end
