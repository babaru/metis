class Collection < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :client
  belongs_to :project
  belongs_to :agency
  belongs_to :space
  has_many :collection_invoices
  attr_accessible :amount, :credit_on, :made_at, :unit,
    :client, :client_id,
    :project, :project_id,
    :agency, :agency_id,
    :space, :space_id,
    :collection_invoice_ids

  def name
    "#{self.made_at.strftime('%Y年%m月%d日')}收#{self.client.name}#{number_to_currency(self.amount, unit: '￥', precision: 0)}"
  end
end
