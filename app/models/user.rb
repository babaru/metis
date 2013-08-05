class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids
  has_many :projects
  has_many :clients, foreign_key: :created_by_id

  has_many :role_assignments
  has_many :roles, through: :role_assignments

  has_many :client_assignments
  has_many :assigned_clients, class_name: 'Client', through: :client_assignments

  has_many :project_assignments
  has_many :assigned_projects, class_name: 'Project', through: :project_assignments

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def viewable_clients
    return clients if has_role?(:admin)

    result = []
    assigned_clients.each {|c| result << c}
    assigned_projects.each {|p| result << p.client unless result.include? p.client}
    result
  end

  def viewable_projects
  end

  def self.all_the_other_users(user)
    result = []
    User.all.each do |u|
      result << u if u.id != user.id
    end
    result
  end
end
