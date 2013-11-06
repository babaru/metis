class SpaceUserRole < ActiveRecord::Base
  belongs_to :space_user
  belongs_to :role
  attr_accessible :space_user_id, :role_id
end
