class Client < ActiveRecord::Base
  include Tida::Paperclip::AttachmentAccessToken
  before_create :generate_access_token
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  attr_accessible :logo, :name, :created_by_id, :created_by
  has_attached_file :logo, :styles => { :thumb => "180x180>" },
    :path => ":rails_root/public:url",
    :url => "/system/client_logos/:attachment_access_token/pic_:style.:extension"
end
