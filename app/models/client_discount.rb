class ClientDiscount < ActiveRecord::Base
  belongs_to :client
  belongs_to :media
  attr_accessible :client_id, :media_id, :media_discount, :company_discount,
    :media_bonus_ratio, :company_bonus_ratio
end
