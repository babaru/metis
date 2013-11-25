class PaymentInvoice < ActiveRecord::Base
  belongs_to :payment
  belongs_to :vendor
  belongs_to :medium
  belongs_to :space

  attr_accessible :amount,
    :invoice_type_id,
    :number,
    :received_at,
    :unit,
    :payment, :payment_id,
    :vendor, :vendor_id,
    :medium, :medium_id,
    :space, :space_id

  scope :ion, where('payment_id IS NULL')
  scope :in_space, lambda{|space| where(space_id: space.id)}

  def name
    "#{self.vendor.nil? ? (self.medium.nil? ? nil : self.medium.name) : self.vendor.name}-#{self.received_at.strftime('%Y-%m-%d %H:%M:%S')}-#{self.amount}"
  end
end
