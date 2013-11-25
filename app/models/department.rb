class Department < ActiveRecord::Base
  belongs_to :space
  has_many :department_users
  has_many :users, through: :department_users
  has_many :department_permissions
  has_many :permissions, through: :department_permissions
  attr_accessible :name, :space, :space_id, :permission_ids, :user_ids
end
