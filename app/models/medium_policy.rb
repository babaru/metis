class MediumPolicy < ActiveRecord::Base
  belongs_to :medium
  belongs_to :client
  belongs_to :medium

  attr_accessible :medium_discount, :company_discount,
    :medium_bonus_ratio, :company_bonus_ratio,
    :cpm_discount,
    :client, :client_id,
    :medium, :medium_id,
    :channel, :channel_id
end

%w(medium_discount company_discount medium_bonus_ratio company_bonus_ratio cpm_discount).each do |name|
MediumPolicy.instance_eval %Q(
  def #{name}(medium_id, client_id)
    mp = MediumPolicy.find_by_medium_id_and_client_id(medium_id, client_id)
    return nil unless mp
    mp.#{name}
  end
)
end
