class MediumMasterPlan < ActiveRecord::Base
  belongs_to :master_plan
  belongs_to :medium
  attr_accessible :company_net_cost, :medium_net_cost
end
