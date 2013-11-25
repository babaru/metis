class Payment < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :medium
  belongs_to :vendor
  belongs_to :space
  has_many :payment_invoices
  attr_accessible :credit_on,
    :paid_at,
    :unit,
    :amount,
    :client, :client_id,
    :project, :project_id,
    :medium, :medium_id,
    :vendor, :vendor_id,
    :space, :space_id,
    :payment_invoice_ids

  scope :in_space, lambda{|space| where(space_id: space.id)}

  before_create :set_mandatory_attributes

  def name
    "#{self.medium.name}-#{self.paid_at.strftime('%Y%m%d%H%M%S')}-#{self.amount}"
  end

  private

  def set_mandatory_attributes
  end
end
