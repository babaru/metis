class Website < ActiveRecord::Base
  include Tida::Paperclip::AttachmentAccessToken
  before_create :generate_access_token
  attr_accessible :attachment_access_token, :logo, :name, :url
  has_attached_file :logo, :styles => { :thumb => "32x32>" },
    :path => ":rails_root/public:url",
    :url => "/system/website_logos/:attachment_access_token/pic_:style.:extension"
end
