class SpaceUser < ActiveRecord::Base
  belongs_to :space
  belongs_to :user
  has_many :space_user_roles
  has_many :roles, through: :space_user_roles
  attr_accessible :space_id, :user_id, :space, :user, :role_ids
end
