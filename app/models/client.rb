class Client < ActiveRecord::Base
  include Tida::Paperclip::AttachmentAccessToken
  before_create :generate_access_token
  before_save :copy_mandatory_attributes

  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  belongs_to :space
  has_many :projects, dependent: :destroy
  has_many :client_assignments, dependent: :destroy
  has_many :assigned_users, class_name: 'User', through: :client_assignments
  has_many :discounts, class_name: 'ClientDiscount', foreign_key: :client_id, dependent: :destroy
  attr_accessible :logo, :name, :created_by_id, :created_by, :assigned_user_ids,
    :space_id, :space

  has_attached_file :logo, :styles => { :thumb => "160x160>" },
    :path => ":rails_root/public:url",
    :url => "/system/client_logos/:attachment_access_token/pic_:style.:extension"

  def created_by?(user)
    user.id == created_by_id
  end

  def belongs_to_any_space?(spaces)
    spaces.include?(self.space)
  end

  def method_missing(m, *args, &block)
    Rails.logger.debug m.class
    if [:medium_discount, :company_discount, :medium_bonus_ratio, :company_bonus_ratio].include?(m)
      result = discounts.where(medium_id: args[0]).first
      return 0 unless result
      return result.send(m)
    end
    puts "There's no method called #{m} here -- please try again."
  end

  private

  def copy_mandatory_attributes
    self[:space_name] = self.space.name
  end

end
