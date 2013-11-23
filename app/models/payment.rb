class Payment < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :medium
  belongs_to :vendor
  belongs_to :space
  has_one :payment_invoice
  attr_accessible :credit_on,
    :paid_at,
    :unit,
    :amount,
    :client, :client_id,
    :project, :project_id,
    :medium, :medium_id,
    :vendor, :vendor_id
end
