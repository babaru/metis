class Channel < ActiveRecord::Base
  belongs_to :media
  belongs_to :channel_group
  has_many :spots, dependent: :destroy
  attr_accessible :name, :names, :media_id, :channel_group_id
  attr_accessor :names

  # validates :name, uniqueness: true

  def self.find_or_create_by_data!(data)
    channel = Channel.find_by_name_and_media_id(data[:name], data[:media_id])
    params = {
      name: data[:name],
      media_id: data[:media_id]
    }
    if channel.nil?
      Rails.logger.error "Can not find channel named #{data[:name]} of media: #{data[:media_id]}"
      channel = Channel.create!(params)
    else
      channel.update_attributes!(params)
    end
    channel
  end
end
