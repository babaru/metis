module Tida
  module Metis
    module SpaceHelper
      def current_space
        return nil unless current_user
        return nil if current_user && current_user_spaces.count == 0
        session[:space_id] = current_user_spaces.first.id unless session[:space_id]
        Space.find(session[:space_id])
      end

      def current_user_spaces
        return Space.all if current_user.is_sys_admin?
        current_user.spaces
      end
    end
  end
end
