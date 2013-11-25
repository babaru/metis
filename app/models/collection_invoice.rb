class CollectionInvoice < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :collection
  belongs_to :space
  belongs_to :client
  belongs_to :agency
  attr_accessible :amount, :invoice_type_id, :number, :sent_at, :unit,
    :collection, :collection_id,
    :space, :space_id,
    :client, :client_id,
    :agency, :agency_id

  scope :ion, where('collection_id IS NULL')
  scope :in_space, lambda{|space| where(space_id: space.id)}

  def name
    "#{self.sent_at.strftime('%Y年%m月%d日')}发给#{self.agency_id.nil? ? self.client.name : self.agency.name}#{number_to_currency(self.amount, unit: '￥', precision: 0)}#{CollectionInvoice.model_name.human}"
  end
end
