class Spot < ActiveRecord::Base
  belongs_to :website
  belongs_to :channel
  attr_accessible :name, :price, :spec, :unit, :remark, :website_id, :channel_id
  serialize :spec, Hash
end
