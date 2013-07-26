class Spot < ActiveRecord::Base
  include Tida::Paperclip::AttachmentAccessToken
  before_create :generate_access_token

  belongs_to :website
  belongs_to :channel
  belongs_to :spot_category

  attr_accessible :name, :price, :spec, :unit, :remark, :website_id, :channel_id, :sample, :attachment_access_token, :spot_category_id
  serialize :spec, Hash

  has_attached_file :sample, :styles => { :thumb => "200x200>" },
    :path => ":rails_root/public:url",
    :url => "/system/spot_samples/:attachment_access_token/pic_:style.:extension"

  def self.find_or_create_by_data!(data)
    spot = Spot.find_by_name_and_channel_id(data[:name], data[:channel_id])
    params = {
      name: data[:name],
      channel_id: data[:channel_id],
      website_id: data[:website_id],
      spot_category_id: data[:spot_category_id],
      price: data[:price],
      unit: data[:unit],
      remark: data[:remark],
      spec: data[:spec]
    }
    if spot.nil?
      Spot.create!(params)
    else
      spot.update_attributes!(params)
    end
  end
end
