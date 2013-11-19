class Project < ActiveRecord::Base
  belongs_to :space
  belongs_to :client
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_many :project_assignments, dependent: :destroy
  has_many :assigned_users, through: :project_assignments
  has_many :master_plans, dependent: :destroy
  has_one :current_master_plan, class_name: 'MasterPlan', foreign_key: :current_master_plan_id

  attr_accessible :ended_at, :name, :started_at, :created_by_id,
    :created_by_name, :created_by, :client_id, :client_name,
    :client, :budget, :assigned_user_ids, :current_master_plan_id,
    :is_started, :is_started_at

  before_create :copy_name_attributes, :create_default_master_plan
  after_create :set_current_master_plan

  validates :name, presence: true
  validates :budget, presence: true
  validates :budget, numericality: { greater_than: 0 }
  validates :started_at, presence: true
  validates :ended_at, presence: true

  scope :started, where(is_started: true)

  def assigned_to?(user)
    assigned_to_user = assigned_to
    return assigned_to_user.id == user.id if assigned_to_user
    return false
  end

  def belongs_to_any_space?(spaces)
    spaces.include?(self.space)
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

  def duration
    (self.ended_at - self.started_at).to_i / 1.day + 1
  end

  def duration_by_month(year, month)
    return (1.months.since(Time.new(year, month)) - self.started_at).to_i / 1.days if self.started_at.year == year && self.started_at.month == month
    return (self.ended_at - Time.new(year, month)).to_i / 1.days + 1 if self.ended_at.year == year && self.ended_at.month == month
    Time.days_in_month(month, year)
  end

  def remove_master_plan(master_plan, user)
    Project.transaction do
      master_plan.destroy
      if self.master_plans.count == 0
        new_master_plan = MasterPlan.create_by_data!({
          client_id: client_id,
          project_id: self.id
          }, user)
      end
      self.current_master_plan_id = self.master_plans.order('created_at DESC').first.id
      self.save!
    end
  end

  def add_master_plan(data, user)
    Project.transaction do
      @master_plan = MasterPlan.create_by_data!(data, user)
      self.current_master_plan_id = @master_plan.id
      self.save!
    end
    @master_plan
  end

  def clone_master_plan(master_plan, user)
    Project.transaction do
      @new_master_plan = master_plan.clone(user)
      self.current_master_plan_id = @new_master_plan.id
      self.save!
    end
    @new_master_plan
  end

  def start!
    unless self.is_started
      self.is_started = true
      self.is_started_at = Time.now
      self.save!
    end
  end

  class << self

    def create_by_data!(data, user)
      data[:created_by_id] = user.id
      Project.create!(data)
    end

  end

  private

  def copy_name_attributes
    client_name = client.name unless client_name
    created_by_name = created_by.name unless created_by_name
  end

  def create_default_master_plan
    master_plans << MasterPlan.new({
      client_id: client_id,
      created_by_id: created_by_id
      })
  end

  def set_current_master_plan
    self.current_master_plan_id = master_plans.order('created_at DESC').first.id
    self.save!
  end
end
