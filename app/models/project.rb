class Project < ActiveRecord::Base
  belongs_to :client
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  attr_accessible :ended_at, :name, :started_at, :created_by_id, :created_by, :client_id, :client, :budget, :budget_unit, :assigned_user_ids
  has_many :project_assignments
  has_many :assigned_users, through: :project_assignments

  def assigned_user?(user)
    false
  end

  def assigned_to
    return assigned_users.first if assigned_users.count > 0
    return created_by
  end
end
