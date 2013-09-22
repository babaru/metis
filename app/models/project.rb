class Project < ActiveRecord::Base
  belongs_to :client
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :project_assignments, dependent: :destroy
  has_many :assigned_users, through: :project_assignments
  has_many :master_plans, dependent: :destroy

  attr_accessible :ended_at, :name, :started_at, :created_by_id, :created_by, :client_id, :client, :budget, :budget_unit, :assigned_user_ids


  def assigned_to?(user)
    assigned_to_user = assigned_to
    return assigned_to_user.id == user.id if assigned_to_user
    return false
  end

  def assigned_to
    return assigned_users.first if assigned_users.count > 0
    nil
  end

  def months
    (started_at.to_datetime..ended_at.to_datetime).map {|m| {year: m.year, month: m.month}}.uniq
  end

  def days
    result = {}
    (started_at.to_datetime..ended_at.to_datetime).map do |m|
      key = m.strftime('%Y%m')
      result[key] = Array.new([ended_at.to_datetime.day, Time.days_in_month(m.month, m.year)].min, 0) if result[key].nil?
      result[key][m.day - 1] = 1
    end
    result
  end
end
