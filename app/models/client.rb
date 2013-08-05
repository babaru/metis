class Client < ActiveRecord::Base
  include Tida::Paperclip::AttachmentAccessToken
  before_create :generate_access_token
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :projects
  has_many :client_assignments
  has_many :assigned_users, class_name: 'User', through: :client_assignments

  attr_accessible :logo, :name, :created_by_id, :created_by, :assigned_user_ids
  has_attached_file :logo, :styles => { :thumb => "160x160>" },
    :path => ":rails_root/public:url",
    :url => "/system/client_logos/:attachment_access_token/pic_:style.:extension"

  def created_by?(user)
    user.id == created_by_id
  end
end
