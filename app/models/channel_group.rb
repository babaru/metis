class ChannelGroup < ActiveRecord::Base
  belongs_to :website
  has_many :channels
  attr_accessible :name, :website_id

  def reset_channels(channel_ids)
    return Channel.where("channel_group_id=#{self.id} and id not in (#{channel_ids.join(',')})") if channel_ids.length > 0
    return self.channels
  end
end
