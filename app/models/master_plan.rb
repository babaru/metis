class MasterPlan < ActiveRecord::Base
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  attr_accessible :project_id, :created_by_id, :name
  has_many :items, class_name: 'MasterPlanItem'
end
