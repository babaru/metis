class Payment < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :medium
  belongs_to :vendor
  belongs_to :space
  has_many :payment_invoices
  attr_accessible :paid_at,
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

  validates :paid_at, presence: true
  validates :amount, presence: true
  validates :medium_id, presence: true
  validates :medium_id, numericality: { greater_than: 0 }

  def name
    "#{self.medium.name}-#{self.paid_at.strftime('%Y%m%d%H%M%S')}-#{self.amount}"
  end

  def invoice_amount
    self.payment_invoices.inject(0) {|sum, item| sum += item.amount}
  end

  def payable(latest_payable, payments)
    payment_amount = 0
    payments.each do |item|
      payment_amount += item.amount
      break if item.id == self.id
    end
    latest_payable - payment_amount
  end

  private

  def set_mandatory_attributes
  end

end
