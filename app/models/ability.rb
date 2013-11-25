class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, :all if user.is_sys_admin?
    can :read, :all

    can do |action, subject_class, subject|
      department_permission = user.departments.any? do |department|
        department.permissions.find_all_by_action(aliases_for_action(action)).any? do |permission|
          permission.subject_class == subject_class.to_s &&
            (subject.nil? || permission.subject_id.nil? || permission.subject_id == subject.id)
        end
      end

      user_permission = user.permissions.find_all_by_action(aliases_for_action(action)).any? do |permission|
        permission.subject_class == subject_class.to_s &&
          (subject.nil? || permission.subject_id.nil? || permission.subject_id == subject.id)
      end

      department_permission || user_permission
    end

    can :update, Project do |project|
      user.assigned_to_client?(project.client) || user.assigned_to_project?(project)
    end

    can :destroy, Project do |project|
      user.assigned_to_client?(project.client)
    end

    can :update, Client do |client|
      user.assigned_to_client?(client)
    end
  end
end
