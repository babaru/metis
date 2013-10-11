class Medium < ActiveRecord::Base
  include Tida::Paperclip::AttachmentAccessToken
  before_create :generate_access_token

  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :channels
  has_many :channel_groups
  has_many :spot_categories
  has_many :spots
  has_many :master_plan_items
  has_many :spot_plan_items
  has_many :client_discounts

  attr_accessible :attachment_access_token, :logo, :name, :type, :url, :created_by_id
  has_attached_file :logo, :styles => { :thumb => "80x80>" },
    :path => ":rails_root/public:url",
    :url => "/system/medium_logos/:attachment_access_token/pic_:style.:extension"
end
