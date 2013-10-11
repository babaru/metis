class ClientDiscount < ActiveRecord::Base
  belongs_to :client
  belongs_to :medium
  attr_accessible :client_id, :medium_id, :medium_discount, :company_discount,
    :medium_bonus_ratio, :company_bonus_ratio
end
