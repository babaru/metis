class Website < ActiveRecord::Base
  include Tida::Paperclip::AttachmentAccessToken
  before_create :generate_access_token
  attr_accessible :attachment_access_token, :logo, :name, :url
  has_attached_file :logo, :styles => { :thumb => "80x80>" },
    :path => ":rails_root/public:url",
    :url => "/system/website_logos/:attachment_access_token/pic_:style.:extension"

  has_many :channels
  has_many :channel_groups
  has_many :spot_categories
  has_many :spots
  has_many :master_plan_items
  has_many :spot_plan_items
  has_many :client_discounts
end
