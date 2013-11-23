class ProjectSearch < Project
  # attr_accessor :client_id, :is_started, :started_at, :ended_at
  # attr_accessible :client_id, :is_started, :started_at, :ended_at

  def projects
    @projects ||= find_projects
  end

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  private

  def find_projects
    Project.find(:all, :conditions => conditions)
  end

  def client_conditions
    ["projects.client_id = ?", client_id] unless client_id.blank?
  end

  def duration_conditions
    ["((projects.started_at BETWEEN ? AND ?) OR (projects.ended_at BETWEEN ? AND ?))", started_at, ended_at, started_at, ended_at] unless started_at.blank? || ended_at.blank?
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end
