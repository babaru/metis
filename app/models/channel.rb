class Channel < ActiveRecord::Base
  belongs_to :website
  attr_accessible :name, :names, :website_id
  attr_accessor :names

  # validates :name, uniqueness: true
end
