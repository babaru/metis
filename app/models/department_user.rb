class DepartmentUser < ActiveRecord::Base
  belongs_to :department
  belongs_to :user
  # attr_accessible :title, :body
end
