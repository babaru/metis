class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_sys_admin?
      can :manage, :all
    else

      # User
      # ------------------------------------------------------------------------

      can :manage, user

      can :manage, User do |u|
        user.is_space_admin_of_any_space?(u.spaces)
      end

      # Space
      # ------------------------------------------------------------------------

      can :update, Space do |space|
        user.belongs_to_space?(space) && (user.is_space_admin?(space) || user.is_space_super_user?(space))
      end

      can :read, Space do |space|
        user.belongs_to_space?(space)
      end

      # Client

      can :manage, Client do |c|
        user.belongs_to_space?(c.space) && user.is_space_admin?(c.space)
      end

      can :update, Client do |c|
        user.assigned_to_client?(c)
      end

      can :read, Client do |c|
        user.belongs_to_space?(c.space)
      end

      # Project

      can :manage, Project do |p|
        user.belongs_to_space?(p.client.space) && (user.is_space_admin?(p.client.space) || user.is_space_super_user?(p.client.space))
      end

      can :manage, Project do |p|
        user.assigned_to_client?(p.client)
      end

      can :read, Project do |p|
        user.belongs_to_space?(p.client.space)
      end

      # MediumPolicy

      can :manage, MediumPolicy do |mp|
        user.belongs_to_space?(mp.client.space) && user.is_space_admin?(mp.client.space)
      end

      can :read, MediumPolicy do |p|
        user.belongs_to_space?(mp.client.space)
      end

      # MasterPlan

      can :manage, MasterPlan do |mp|
        user.belongs_to_space?(mp.client.space) && (user.is_space_admin?(mp.client.space) || user.is_space_super_user?(mp.client.space))
      end

      can :manage, MasterPlan do |mp|
        user.assigned_to_client?(mp.client)
      end

      can :manage, MasterPlan do |mp|
        user.assigned_to_project?(mp.project)
      end

      can :read, MasterPlan do |mp|
        user.belongs_to_space?(mp.client.space)
      end

    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
