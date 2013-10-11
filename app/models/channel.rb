class Channel < ActiveRecord::Base
  belongs_to :medium
  belongs_to :channel_group
  has_many :spots, dependent: :destroy
  attr_accessible :name, :names, :medium_id, :channel_group_id
  attr_accessor :names

  # validates :name, uniqueness: true

  def self.find_or_create_by_data!(data)
    channel = Channel.find_by_name_and_medium_id(data[:name], data[:medium_id])
    params = {
      name: data[:name],
      medium_id: data[:medium_id]
    }
    if channel.nil?
      Rails.logger.error "Can not find channel named #{data[:name]} of medium: #{data[:medium_id]}"
      channel = Channel.create!(params)
    else
      channel.update_attributes!(params)
    end
    channel
  end
end
