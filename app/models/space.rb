class Space < ActiveRecord::Base
  attr_accessible :name, :user_ids, :client_ids
  has_many :space_users
  has_many :users, through: :space_users
  has_many :clients

  validates :name, uniqueness: true
end
