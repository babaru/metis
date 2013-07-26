class Channel < ActiveRecord::Base
  belongs_to :website
  belongs_to :channel_group
  has_many :spots
  attr_accessible :name, :names, :website_id, :channel_group_id
  attr_accessor :names

  # validates :name, uniqueness: true

  def self.find_or_create_by_data!(data)
    channel = Channel.find_by_name_and_website_id(data[:name], data[:website_id])
    params = {
      name: data[:name],
      website_id: data[:website_id]
    }
    if channel.nil?
      Rails.logger.error "Can not find channel named #{data[:name]} of website: #{data[:website_id]}"
      channel = Channel.create!(params)
    else
      channel.update_attributes!(params)
    end
    channel
  end
end
