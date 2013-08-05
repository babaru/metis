class ProjectAssignment < ActiveRecord::Base
  belongs_to :assigned_project, class_name: 'Project', foreign_key: :project_id
  belongs_to :assigned_user, class_name: 'User', foreign_key: :user_id
  # attr_accessible :title, :body
end
