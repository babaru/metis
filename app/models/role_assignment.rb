class RoleAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :space
  attr_accessible :user_id, :role_id, :space_id
end
