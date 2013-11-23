class Department < ActiveRecord::Base
  belongs_to :space
  attr_accessible :name
end
