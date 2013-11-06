class Role < ActiveRecord::Base
  attr_accessible :name, :readable_name, :type
  has_many :role_assignments
  has_many :users, through: :role_assignments

  scope :space_roles, where(type: Role.name)

  def human_name
    return readable_name if readable_name
    name
  end
end
