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

  def name
    "#{self.vendor.nil? ? (self.medium.nil? ? nil : self.medium.name) : self.vendor.name}-#{self.received_at.strftime('%Y-%m-%d %H:%M:%S')}-#{self.amount}"
  end

  class << self
    def invoice_types
      ::Tida::Metis::InvoiceType.invoice_types.map{ |k,v| [I18n.t("invoice_types.#{k}"),v] }
    end

    def invoice_type_names
      Hash[::Tida::Metis::InvoiceType.invoice_types.map{ |k, v| [v, I18n.t("invoice_types.#{k}")]}]
    end
  end
end
