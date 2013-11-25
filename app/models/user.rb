class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :role_ids, :space_ids, :space_roles
  has_many :projects
  has_many :clients, foreign_key: :created_by_id

  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments

  has_many :client_assignments, dependent: :destroy
  has_many :assigned_clients, class_name: 'Client', through: :client_assignments

  has_many :project_assignments, dependent: :destroy
  has_many :assigned_projects, class_name: 'Project', through: :project_assignments

  has_many :space_users, dependent: :destroy
  has_many :spaces, through: :space_users
  has_many :space_user_roles, through: :space_users, dependent: :destroy

  has_many :user_permissions
  has_many :permissions, through: :user_permissions

  has_many :department_users
  has_many :departments, through: :department_users

  attr_accessor :current_space_id, :space_roles

  def is_sys_admin?
    has_sys_role? :sys_admin
  end

  def is_space_admin?(space)
    has_space_role? :space_admin, space
  end

  def is_space_admin_of_any_space?(spaces)
    spaces.any? {|space| user.is_space_admin?(space)}
  end

  def is_space_super_user?(space)
    has_space_role? :space_super_user, space
  end

  def is_space_user?(space)
    has_space_role? :user, space
  end

  def belongs_to_any_space?(spaces)
    spaces.any? {|space| SpaceUser.find_by_user_id_and_space_id(self.id, space.id) != nil}
  end

  def belongs_to_space?(space)
    SpaceUser.find_by_user_id_and_space_id(self.id, space.id) != nil
  end

  def assigned_to_project?(project)
    assigned_projects.include? project
  end

  def assigned_to_client?(client)
    assigned_clients.include? client
  end

  def space_roles(space)
    space_user = SpaceUser.find_by_user_id_and_space_id(self.id, space.id)
    if space_user
      space_user_roles = SpaceUserRole.where(space_user_id: space_user.id)
      return space_user_roles.inject([]) {|list, space_user_role| list << space_user_role.role }
    end
    []
  end


  def self.all_the_other_users(user)
    result = []
    User.all.each do |u|
      result << u if u.id != user.id
    end
    result
  end

  private

  def has_sys_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def has_space_role?(role_sym, space)
    space_user_roles.any? { |r| r.role.name.underscore.to_sym == role_sym && r.space_user.space_id == space.id } if space
  end
end
