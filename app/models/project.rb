class Project < ActiveRecord::Base
  belongs_to :client
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  attr_accessible :ended_at, :name, :started_at, :created_by_id, :created_by, :client_id, :client
end
