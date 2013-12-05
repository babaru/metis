class CompanyPolicyItem < ActiveRecord::Base
  belongs_to :company_policy
  attr_accessible :max, :min, :rebate, :remark, :company_policy, :company_policy_id
end
