class SpotContract < ActiveRecord::Base
  belongs_to :client
  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  has_and_belongs_to_many :spots
  attr_accessible :client_id, :project_id, :created_by_id
end
