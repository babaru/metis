class SpotCategory < ActiveRecord::Base
  include Tida::Paperclip::AttachmentAccessToken
  before_create :generate_access_token

  attr_accessible :attachment_access_token, :description, :name, :sample, :media_id

  has_attached_file :sample, :styles => { :thumb => "100x100>" },
    :path => ":rails_root/public:url",
    :url => "/system/spot_category_samples/:attachment_access_token/pic_:style.:extension"

  has_many :spots
  belongs_to :media

  def self.find_or_create_by_data!(data)
    spot_category = SpotCategory.find_by_name_and_media_id(data[:name], data[:media_id])
    params = {
      name: data[:name],
      description: data[:description],
      media_id: data[:media_id]
    }
    if spot_category.nil?
      spot_category = SpotCategory.create!(params)
    else
      spot_category.update_attributes!(params)
    end
    spot_category
  end
end
