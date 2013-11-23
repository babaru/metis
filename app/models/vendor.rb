class Vendor < ActiveRecord::Base
  belongs_to :space
  attr_accessible :name, :type, :space, :space_id
end
