class MasterPlanItem < ActiveRecord::Base
  belongs_to :spot
  belongs_to :master_plan
  attr_accessible :count, :spot_id, :master_plan_id
end
