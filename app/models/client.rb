class Client < ActiveRecord::Base
  include Tida::Paperclip::AttachmentAccessToken
  before_create :generate_access_token

  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :projects, dependent: :destroy
  has_many :client_assignments, dependent: :destroy
  has_many :assigned_users, class_name: 'User', through: :client_assignments
  has_many :discounts, class_name: 'ClientDiscount', foreign_key: :client_id, dependent: :destroy

  attr_accessible :logo, :name, :created_by_id, :created_by, :assigned_user_ids
  has_attached_file :logo, :styles => { :thumb => "160x160>" },
    :path => ":rails_root/public:url",
    :url => "/system/client_logos/:attachment_access_token/pic_:style.:extension"

  def created_by?(user)
    user.id == created_by_id
  end

  def website_discount_value(website_id, options={})
    client_discount = discounts.where(website_id: website_id).first
    return client_discount.website_discount_value(options) if client_discount
    0
  end

  def our_discount_value(website_id, options = {})
    client_discount = discounts.where(website_id: website_id).first
    return client_discount.our_discount_value(options) if client_discount
    0
  end

  def on_house_rate(website_id)
    client_discount = discounts.where(website_id: website_id).first
    return client_discount.on_house_rate if client_discount
    0
  end
end
