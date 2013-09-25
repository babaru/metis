class ClientDiscount < ActiveRecord::Base
  belongs_to :client
  belongs_to :website
  attr_accessible :client_id, :website_id, :website_discount, :company_discount,
    :website_bonus_ratio, :company_bonus_ratio
end
