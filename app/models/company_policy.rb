class CompanyPolicy < ActiveRecord::Base
  belongs_to :client
  belongs_to :medium
  has_many :company_policy_items
  attr_accessible :framework, :year, :client, :medium, :client_id, :medium_id, :rebate

  def name
    "#{self.client.name}#{year}年#{self.medium.name}#{CompanyPolicy.model_name.human}"
  end

  def self.rebate(client_id, medium_id)
    cp = CompanyPolicy.find_by_client_id_and_medium_id(client_id, medium_id)
    return nil unless cp
    cp.rebate
  end
end
