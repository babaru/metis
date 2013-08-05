class ClientAssignment < ActiveRecord::Base
  belongs_to :assigned_client, class_name: 'Client', foreign_key: :client_id
  belongs_to :assigned_user, class_name: 'User', foreign_key: :user_id
  # attr_accessible :title, :body
end
